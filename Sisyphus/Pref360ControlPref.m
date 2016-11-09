/*
    MICE Xbox 360 Controller driver for Mac OS X
    Copyright (C) 2006-2013 Colin Munro

    Pref360ControlPref.m - main source of the pref pane

    This file is part of Xbox360Controller.

    Xbox360Controller is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    Xbox360Controller is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Foobar; if not, write to the Free Software
    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
*/
#include <mach/mach.h>
#include <IOKit/usb/IOUSBLib.h>
#import "Pref360ControlPref.h"
#import "DeviceItem.h"
#import "ControlPrefs.h"
#import "DeviceLister.h"

#import "Sisyphus-Swift.h"

#define NO_ITEMS @"No devices found"

// Passes a C callback back to the Objective C class
static void CallbackFunction(void *target,IOReturn result,void *refCon,void *sender)
{
    if (target) [((__bridge Pref360ControlPref*)target) eventQueueFired:sender withResult:result];
}

// Handle callback for when our device is connected or disconnected. Both events are
// actually handled identically.
static void callbackHandleDevice(void *param,io_iterator_t iterator)
{
    io_service_t object = 0;
    BOOL update = NO;

    while ((object = IOIteratorNext(iterator))) {
        IOObjectRelease(object);
        update = YES;
    }

    if (update) [(__bridge Pref360ControlPref*)param handleDeviceChange];
}

@interface Pref360ControlPref ()
@property (strong) Controller *wholeController;
@property (strong) NSMutableArray *deviceArray;
@end

@implementation Pref360ControlPref
{
@private
    // Internal info
    IOHIDElementCookie axis[6],buttons[15];

    IOHIDDeviceInterface122 **device;
    IOHIDQueueInterface **hidQueue;
    FFDeviceObjectReference ffDevice;
    io_registry_entry_t registryEntry;

    int largeMotor, smallMotor;

    IONotificationPortRef notifyPort;
    CFRunLoopSourceRef notifySource;
    io_iterator_t onIteratorWired, offIteratorWired;
    io_iterator_t onIteratorWireless, offIteratorWireless;

    FFEFFECT *effect;
    FFCUSTOMFORCE *customforce;
    FFEffectObjectReference effectRef;
}


-(void)awakeFromNib {
    [_aboutPopover setAppearance: [NSAppearance appearanceNamed:NSAppearanceNameAqua]];
    [_rumbleOptions removeAllItems];
    [_rumbleOptions addItemsWithTitles:@[@"Default", @"None"]];
}

// Set the pattern on the LEDs
- (void)updateLED:(int)ledIndex
{
    FFEFFESCAPE escape = {0};
    unsigned char c = ledIndex;

    if (ffDevice == 0) return;
    escape.dwSize = sizeof(escape);
    escape.dwCommand = 0x02;
    escape.cbInBuffer = sizeof(c);
    escape.lpvInBuffer = &c;
    FFDeviceEscape(ffDevice, &escape);
}

// This will initialize the ff effect.
- (void)testMotorsInit
{
    if (ffDevice == 0) return;

    FFCAPABILITIES capabs;
    FFDeviceGetForceFeedbackCapabilities(ffDevice, &capabs);

    if(capabs.numFfAxes != 2) return;

    effect = calloc(1, sizeof(FFEFFECT));
    customforce = calloc(1, sizeof(FFCUSTOMFORCE));
    LONG *c = calloc(2, sizeof(LONG));
    DWORD *a = calloc(2, sizeof(DWORD));
    LONG *d = calloc(2, sizeof(LONG));

    c[0] = 0;
    c[1] = 0;
    a[0] = capabs.ffAxes[0];
    a[1] = capabs.ffAxes[1];
    d[0] = 0;
    d[1] = 0;

    customforce->cChannels = 2;
    customforce->cSamples = 2;
    customforce->rglForceData = c;
    customforce->dwSamplePeriod = 100*1000;

    effect->cAxes = capabs.numFfAxes;
    effect->rglDirection = d;
    effect->rgdwAxes = a;
    effect->dwSamplePeriod = 0;
    effect->dwGain = 10000;
    effect->dwFlags = FFEFF_OBJECTOFFSETS | FFEFF_SPHERICAL;
    effect->dwSize = sizeof(FFEFFECT);
    effect->dwDuration = FF_INFINITE;
    effect->dwSamplePeriod = 100*1000;
    effect->cbTypeSpecificParams = sizeof(FFCUSTOMFORCE);
    effect->lpvTypeSpecificParams = customforce;
    effect->lpEnvelope = NULL;
    FFDeviceCreateEffect(ffDevice, kFFEffectType_CustomForce_ID, effect, &effectRef);
}

- (void)testMotorsCleanUp
{
    if (effectRef == NULL) return;
    FFDeviceReleaseEffect(ffDevice, effectRef);
    free(customforce->rglForceData);
    free(effect->rgdwAxes);
    free(effect->rglDirection);
    free(customforce);
    free(effect);
}
- (void)testMotorsLarge:(unsigned char)large small:(unsigned char)small
{
    if (effectRef == NULL) return;
    customforce->rglForceData[0] = (large * 10000) / 255;
    customforce->rglForceData[1] = (small * 10000) / 255;
    FFEffectSetParameters(effectRef, effect, FFEP_TYPESPECIFICPARAMS);
    FFEffectStart(effectRef, 1, 0);
}

// Update axis GUI component
- (void)axisChanged:(int)index newValue:(int)value
{
    NSInteger tabIndex = [_tabView indexOfTabViewItem:[_tabView selectedTabViewItem]];

    switch(index) {
        case 0:
			[_wholeController setLpositionX:value];
            break;
        case 1:
			[_wholeController setLpositionY:value];
            break;
        case 2:
            [_wholeController setRpositionX:value];
            break;

        case 3:
            [_wholeController setRpositionY:value];
            break;

        case 4:
            if (tabIndex == 0) { // Controller Test
				[_wholeController setLeftTrigger:value];
                largeMotor=value;
                [self testMotorsLarge:largeMotor small:smallMotor];
            }
            break;

        case 5:
            if (tabIndex == 0) {
				[_wholeController setRightTrigger:value];
                smallMotor=value;
                [self testMotorsLarge:largeMotor small:smallMotor];
            }
            break;

        default:
            break;
    }
}

// Update button GUI component
- (void)buttonChanged:(int)index newValue:(int)value
{
    BOOL b = (value != 0);
    NSInteger tabIndex = [_tabView indexOfTabViewItem:[_tabView selectedTabViewItem]];

    if (tabIndex == 0) { // Controller Test
        switch (index) {
            case 0:
                [_wholeController setA:b];
                break;
            case 1:
				[_wholeController setB:b];
                break;
            case 2:
                [_wholeController setX:b];
                break;
            case 3:
                [_wholeController setY:b];
                break;

            case 4:
                [_wholeController setLb:b];
                break;

            case 5:
                [_wholeController setRb:b];
                break;

            case 6:
                [_wholeController setLpressed:b];
                break;

            case 7:
                [_wholeController setRpressed:b];
                break;

            case 8:
                [_wholeController setStart:b];
                break;

            case 9:
                [_wholeController setBack:b];
                break;

            case 10:
                [_wholeController setHome:b];
                break;

            case 11:
                [_wholeController setUp:b];
                break;

            case 12:
                [_wholeController setDown:b];
                break;

            case 13:
                [_wholeController setLeft:b];
                break;

            case 14:
                [_wholeController setRight:b];
                break;

            default:
                break;
        }
    }
}

// Handle message from I/O Kit indicating something happened on the device
- (void)eventQueueFired:(void*)sender withResult:(IOReturn)result
{
    AbsoluteTime zeroTime = {0,0};
    IOHIDEventStruct event;
    BOOL found = NO;
    int i;

    if (sender != hidQueue) return;
    while (result == kIOReturnSuccess) {
        result = (*hidQueue)->getNextEvent(hidQueue,&event,zeroTime,0);
        if (result != kIOReturnSuccess) continue;
        // Check axis
        for (i = 0, found = NO; (i < 6) && !found; i++) {
            if (event.elementCookie == axis[i]) {
                [self axisChanged:i newValue:event.value];
                found = YES;
            }
        }
        if (found) continue;
        // Check buttons
        for (i = 0, found = NO; (i < 15) && !found; i++) {
            if(event.elementCookie==buttons[i]) {
                [self buttonChanged:i newValue:event.value];
                found = YES;
            }
        }
        if(found) continue;
        // Cookie wasn't for us?
    }
}

// Reset GUI components
- (void)resetDisplay
{
    [_wholeController reset];
}

// Stop using the HID device
- (void)stopDevice
{
    if(registryEntry==0) return;
    [self testMotorsLarge:0 small:0];
    [self testMotorsCleanUp];
    if (hidQueue) {
        CFRunLoopSourceRef eventSource;

        (*hidQueue)->stop(hidQueue);
        eventSource=(*hidQueue)->getAsyncEventSource(hidQueue);
        if((eventSource!=NULL)&&CFRunLoopContainsSource(CFRunLoopGetCurrent(),eventSource,kCFRunLoopCommonModes))
            CFRunLoopRemoveSource(CFRunLoopGetCurrent(),eventSource,kCFRunLoopCommonModes);
        (*hidQueue)->Release(hidQueue);
        hidQueue = NULL;
    }
    if (device) {
        (*device)->close(device);
        device = NULL;
    }
    registryEntry = 0;
}

// Start using a HID device
- (void)startDevice
{
    int i = (int)[_deviceList indexOfSelectedItem];
    int j;
    CFArrayRef CFelements;
    IOHIDElementCookie cookie;
    long usage,usagePage;
    CFRunLoopSourceRef eventSource;
    IOReturn ret;

    [self resetDisplay];
    if(([_deviceArray count]==0)||(i==-1)) {
        NSLog(@"No devices found? :( device count==%i, i==%i",(int)[_deviceArray count], i);
        return;
    }
    {
        DeviceItem *item = _deviceArray[i];

        device = [item hidDevice];
        ffDevice = [item ffDevice];
        registryEntry = [item rawDevice];
        controllerType = [item controllerType];
        
        if (controllerType == XboxOneController || controllerType == XboxOnePretend360Controller)
        {
            [_rumbleOptions removeAllItems];
            [_rumbleOptions addItemsWithTitles:@[@"Default", @"None", @"Triggers Only", @"Both"]];
        }
        else
        {
            [_rumbleOptions removeAllItems];
            [_rumbleOptions addItemsWithTitles:@[@"Default", @"None"]];
        }
    }

    if((*device)->copyMatchingElements(device,NULL,&CFelements)!=kIOReturnSuccess) {
        NSLog(@"Can't get elements list");
        // Make note of failure?
        return;
    }

    NSArray *elements = CFBridgingRelease(CFelements);

    for (NSDictionary *element in elements) {
        id object;
        // Get cookie
        object = element[@kIOHIDElementCookieKey];
        if (object == nil || ![object isKindOfClass:[NSNumber class]]) {
            continue;
        }
        cookie = (IOHIDElementCookie)[(NSNumber*)object unsignedIntValue];
        // Get usage
        object = element[@kIOHIDElementUsageKey];
        if (object == nil || ![object isKindOfClass:[NSNumber class]]) {
            continue;
        }
        usage = [(NSNumber*)object longValue];
        // Get usage page
        object = element[@kIOHIDElementUsagePageKey];
        if (object == nil || ![object isKindOfClass:[NSNumber class]]) {
            continue;
        }
        usagePage = [(NSNumber*)object longValue];
        // Match up items
        switch(usagePage) {
            case 0x01:  // Generic Desktop
                j=0;
                switch(usage) {
                    case 0x35:  // Right trigger
                        j++;
                    case 0x32:  // Left trigger
                        j++;
                    case 0x34:  // Right stick Y
                        j++;
                    case 0x33:  // Right stick X
                        j++;
                    case 0x31:  // Left stick Y
                        j++;
                    case 0x30:  // Left stick X
                        axis[j]=cookie;
                        break;
                    default:
                        break;
                }
                break;
            case 0x09:  // Button
                if((usage>=1)&&(usage<=15)) {
                    // Button 1-11
                    buttons[usage-1]=cookie;
                }
                break;
            default:
                break;
        }
    }
    // Start queue
    if((*device)->open(device,0)!=kIOReturnSuccess) {
        NSLog(@"Can't open device");
        // Make note of failure?
        return;
    }
    hidQueue=(*device)->allocQueue(device);
    if(hidQueue==NULL) {
        NSLog(@"Unable to allocate queue");
        // Error?
        return;
    }
    ret=(*hidQueue)->create(hidQueue,0,32);
    if(ret!=kIOReturnSuccess) {
        NSLog(@"Unable to create the queue");
        // Error?
        return;
    }
    // Create event source
    ret=(*hidQueue)->createAsyncEventSource(hidQueue, &eventSource);
    if(ret!=kIOReturnSuccess) {
        NSLog(@"Unable to create async event source");
        // Error?
        return;
    }
    // Set callback
    ret=(*hidQueue)->setEventCallout(hidQueue, CallbackFunction, (__bridge void *)(self), NULL);
    if(ret!=kIOReturnSuccess) {
        NSLog(@"Unable to set event callback");
        // Error?
        return;
    }
    // Add to runloop
    CFRunLoopAddSource(CFRunLoopGetCurrent(), eventSource, kCFRunLoopCommonModes);
    // Add some elements
    for (i = 0; i < 6; i++)
        (*hidQueue)->addElement(hidQueue, axis[i], 0);
    for (i = 0; i < 15; i++)
        (*hidQueue)->addElement(hidQueue, buttons[i], 0);
    // Start
    ret = (*hidQueue)->start(hidQueue);
    if (ret != kIOReturnSuccess) {
        NSLog(@"Unable to start queue - 0x%.8x", ret);
        // Error?
        return;
    }
    // Read existing properties
    {
        // CFDictionaryRef dict=(CFDictionaryRef)IORegistryEntryCreateCFProperty(registryEntry,CFSTR("DeviceData"),NULL,0);
        CFDictionaryRef dict = (CFDictionaryRef)CFBridgingRetain(GetController(GetSerialNumber(registryEntry)));
        if(dict) {
            CFBooleanRef boolValue;
            CFNumberRef intValue;

            if(CFDictionaryGetValueIfPresent(dict,CFSTR("DeadOffLeft"),(void*)&boolValue)) {
                BOOL enable=CFBooleanGetValue(boolValue);
                [_wholeController setLnormalized:enable];
            } else NSLog(@"No value for DeadOffLeft\n");
            if(CFDictionaryGetValueIfPresent(dict,CFSTR("DeadzoneLeft"),(void*)&intValue)) {
                UInt16 i;
                CFNumberGetValue(intValue,kCFNumberShortType,&i);
                [_wholeController setLdeadZone:i];
            } else NSLog(@"No value for DeadzoneLeft\n");
            if(CFDictionaryGetValueIfPresent(dict,CFSTR("RelativeRight"),(void*)&boolValue)) {
                [_wholeController setRdeadZone:i];
            } else NSLog(@"No value for RelativeRight\n");
            if(CFDictionaryGetValueIfPresent(dict,CFSTR("DeadOffRight"),(void*)&boolValue)) {
                BOOL enable=CFBooleanGetValue(boolValue);
                [_wholeController setRnormalized:enable];
            } else NSLog(@"No value for DeadOffRight\n");
            if(CFDictionaryGetValueIfPresent(dict,CFSTR("DeadzoneRight"),(void*)&intValue)) {
                UInt16 i;
                CFNumberGetValue(intValue,kCFNumberShortType,&i);
                [_wholeController setRdeadZone:i];
            } else NSLog(@"No value for DeadzoneRight\n");

            if(CFDictionaryGetValueIfPresent(dict,CFSTR("ControllerType"),(void*)&intValue)) {
                NSNumber *num = (__bridge NSNumber *)intValue;
                ControllerType controllerTypePrefs = (ControllerType)[num integerValue];
                if (controllerTypePrefs != controllerType)
                    NSLog(@"ControllerType from prefs was %d, expected %d", (int)controllerTypePrefs, (int)controllerType);
            } else NSLog(@"No value for ControllerType\n");
        } else NSLog(@"No settings found\n");
    }
    // Set device capabilities
    // Set FF motor control
    [self testMotorsInit];
    [self testMotorsLarge:0 small:0];
    largeMotor = 0;
    smallMotor = 0;
    // Battery level?
    {
        int batteryLevel = -1;
        int batteryPercentage = -1;
        CFTypeRef prop;

        if (IOObjectConformsTo(registryEntry, "WirelessHIDDevice")) {
            prop = IORegistryEntryCreateCFProperty(registryEntry, CFSTR("BatteryLevel"), NULL, 0);
            if (prop != nil) {
                unsigned char level;

                if (CFNumberGetValue(prop, kCFNumberCharType, &level)) {
                    batteryLevel = level / 64;
                    batteryPercentage = level * 100 / 255.0f + 0.5f;
                }
                CFRelease(prop);
            }
            [_powerOff setHidden:NO];
        }
        [_wholeController setBatteryPercentage:batteryPercentage];
    }

    [_mappingTable reloadData];
}

// Clear out the device lists
- (void)deleteDeviceList
{
    [_deviceList removeAllItems];
    [_deviceListBinding removeAllItems];
    [_deviceListAdvanced removeAllItems];
    [_deviceArray removeAllObjects];
}

// Update the device list from the I/O Kit
- (void)updateDeviceList
{
    CFMutableDictionaryRef hidDictionary;
    IOReturn ioReturn;
    io_iterator_t iterator;
    io_object_t hidDevice;
    int count = 0;

    // Scrub old items
    [self stopDevice];
    [self deleteDeviceList];
    // Add new items
    hidDictionary=IOServiceMatching(kIOHIDDeviceKey);
    ioReturn=IOServiceGetMatchingServices(_masterPort,hidDictionary,&iterator);
    if((ioReturn != kIOReturnSuccess) || (iterator == 0)) {
        [_deviceList addItemWithTitle:NO_ITEMS];
        [_deviceListBinding addItemWithTitle:NO_ITEMS];
        [_deviceListAdvanced addItemWithTitle:NO_ITEMS];
        return;
    }

    while ((hidDevice = IOIteratorNext(iterator))) {
		io_object_t parent = 0;
		IORegistryEntryGetParentEntry(hidDevice, kIOServicePlane, &parent);
        BOOL deviceWired = IOObjectConformsTo(parent, "Xbox360Peripheral") && IOObjectConformsTo(hidDevice, "Xbox360ControllerClass");
        BOOL deviceWireless = IOObjectConformsTo(hidDevice, "WirelessHIDDevice");
        if ((!deviceWired) && (!deviceWireless))
        {
            IOObjectRelease(hidDevice);
            continue;
        }
        DeviceItem *item = [DeviceItem allocateDeviceItemForDevice:hidDevice];
        if (item == nil) continue;
        // Add to item
        NSString *name = item.displayName;
        [_deviceList addItemWithTitle:[NSString stringWithFormat:@"%i: %@ (%@)", ++count, name, deviceWireless ? @"Wireless" : @"Wired"]];
        [_deviceListBinding addItemWithTitle:[NSString stringWithFormat:@"%i: %@ (%@)", count, name, deviceWireless ? @"Wireless" : @"Wired"]];
        [_deviceListAdvanced addItemWithTitle:[NSString stringWithFormat:@"%i: %@ (%@)", count, name, deviceWireless ? @"Wireless" : @"Wired"]];
        [_deviceArray addObject:item];
    }
    IOObjectRelease(iterator);
    if (count==0) {
        [_deviceList addItemWithTitle:NO_ITEMS];
        [_deviceListBinding addItemWithTitle:NO_ITEMS];
        [_deviceListAdvanced addItemWithTitle:NO_ITEMS];
    }
    [self startDevice];
}

// Start up
- (void)didSelect
{
    io_object_t object;

    // Get master port, for accessing I/O Kit
    IOMasterPort(MACH_PORT_NULL,&_masterPort);
    // Set up notification of USB device addition/removal
    notifyPort=IONotificationPortCreate(_masterPort);
    notifySource=IONotificationPortGetRunLoopSource(notifyPort);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), notifySource, kCFRunLoopCommonModes);
    // Prepare other fields
    _deviceArray = [[NSMutableArray alloc] initWithCapacity:1];
    device=NULL;
    hidQueue=NULL;
    // Activate callbacks
        // Wired
    IOServiceAddMatchingNotification(notifyPort, kIOFirstMatchNotification, IOServiceMatching(kIOUSBDeviceClassName), callbackHandleDevice, (__bridge void *)(self), &onIteratorWired);
    callbackHandleDevice((__bridge void *)(self), onIteratorWired);
    IOServiceAddMatchingNotification(notifyPort, kIOTerminatedNotification, IOServiceMatching(kIOUSBDeviceClassName), callbackHandleDevice, (__bridge void *)(self), &offIteratorWired);
    while((object = IOIteratorNext(offIteratorWired)) != 0)
        IOObjectRelease(object);
        // Wireless
    IOServiceAddMatchingNotification(notifyPort, kIOFirstMatchNotification, IOServiceMatching("WirelessHIDDevice"), callbackHandleDevice, (__bridge void *)(self), &onIteratorWireless);
    callbackHandleDevice((__bridge void *)(self), onIteratorWireless);
    IOServiceAddMatchingNotification(notifyPort, kIOTerminatedNotification, IOServiceMatching("WirelessHIDDevice"), callbackHandleDevice, (__bridge void *)(self), &offIteratorWireless);
    while((object = IOIteratorNext(offIteratorWireless)) != 0)
        IOObjectRelease(object);

    // TEMP: Enable the "enable driver" checkbox if the kext is loaded in the memory
    int result = system("kextstat | grep com.mice.driver.Xbox360Controller");
//    NSLog(@"Result of kextstat = %d", result);
    if (result == 0) {
        [self.enableDriverCheckBox setState:NSOnState];
    } else {
        [self.enableDriverCheckBox setState:NSOffState];
    }
}

// Shut down
- (void)didUnselect
{
    unsigned char c;

    // Remove notification source
    IOObjectRelease(onIteratorWired);
    IOObjectRelease(onIteratorWireless);
    IOObjectRelease(offIteratorWired);
    IOObjectRelease(offIteratorWireless);
    CFRunLoopSourceInvalidate(notifySource);
    IONotificationPortDestroy(notifyPort);
    // Release device and info
    [self stopDevice];
    for (DeviceItem *item in _deviceArray)
    {
        FFEFFESCAPE escape = {0};
        NSInteger i = [_deviceArray indexOfObject:item];
        if ([item ffDevice] == 0)
            continue;
        c = 0x06 + (i % 0x04);
        escape.dwSize = sizeof(escape);
        escape.dwCommand = 0x02;
        escape.cbInBuffer = sizeof(c);
        escape.lpvInBuffer = &c;
        escape.cbOutBuffer = 0;
        escape.lpvOutBuffer = NULL;
        FFDeviceEscape([item ffDevice], &escape);
    }
    [self deleteDeviceList];
    // Close master port
    mach_port_deallocate(mach_task_self(), _masterPort);
    // Done
}

// Handle selection from drop down menu
- (IBAction)selectDevice:(id)sender
{
    NSInteger tabIndex = [_tabView indexOfTabViewItem:[_tabView selectedTabViewItem]];
    if (tabIndex == 0) { // Controller Test
        [_deviceListBinding selectItemAtIndex:[_deviceList indexOfSelectedItem]];
        [_deviceListAdvanced selectItemAtIndex:[_deviceList indexOfSelectedItem]];
    }
    else if (tabIndex == 1) { // Binding Tab
        [_deviceList selectItemAtIndex:[_deviceListBinding indexOfSelectedItem]];
        [_deviceListAdvanced selectItemAtIndex:[_deviceListBinding indexOfSelectedItem]];
    }
    else if (tabIndex == 2) { // Deadzones Tab
        [_deviceList selectItemAtIndex:[_deviceListAdvanced indexOfSelectedItem]];
        [_deviceListBinding selectItemAtIndex:[_deviceListAdvanced indexOfSelectedItem]];
    }

    [self startDevice];
}

// Handle changing a setting
- (IBAction)changeSetting:(id)sender
{
    // Send normalize to joysticks
    [_wholeController setLnormalized:(BOOL)[_leftStickNormalize state]];
    [_wholeController setRnormalized:(BOOL)[_rightStickNormalize state]];
    
    BOOL pretend360 = ([_pretend360Button state] == NSOnState);
    if (controllerType == XboxOneController || controllerType == XboxOnePretend360Controller)
    {
        if (pretend360)
            controllerType = XboxOnePretend360Controller;
        else
            controllerType = XboxOneController;
    }

    // Create dictionary
    NSDictionary *dict = @{@"InvertLeftX": @((BOOL)([_leftStickInvertX state]==NSOnState)),
                           @"InvertLeftY": @((BOOL)([_leftStickInvertY state]==NSOnState)),
                           @"InvertRightX": @((BOOL)([_rightStickInvertX state]==NSOnState)),
                           @"InvertRightY": @((BOOL)([_rightStickInvertY state]==NSOnState)),
                           @"DeadzoneLeft": @((UInt16)[_wholeController ldeadZone]),
                           @"DeadzoneRight": @((UInt16)[_wholeController rdeadZone]),
                           @"RelativeLeft": @((BOOL)([_leftLinked state]==NSOnState)),
                           @"RelativeRight": @((BOOL)([_rightLinked state]==NSOnState)),
                           @"DeadOffLeft": @((BOOL)([_leftStickNormalize state]==NSOnState)),
                           @"DeadOffRight": @((BOOL)([_rightStickNormalize state]==NSOnState)),
                           @"ControllerType": @((UInt8)(controllerType)),
                           @"RumbleType": @((UInt8)([_rumbleOptions indexOfSelectedItem])),
                           @"BindingUp": @((UInt8)([[Mapper instance] mapping][0])),
                           @"BindingDown": @((UInt8)([[Mapper instance] mapping][1])),
                           @"BindingLeft": @((UInt8)([[Mapper instance] mapping][2])),
                           @"BindingRight": @((UInt8)([[Mapper instance] mapping][3])),
                           @"BindingStart": @((UInt8)([[Mapper instance] mapping][4])),
                           @"BindingBack": @((UInt8)([[Mapper instance] mapping][5])),
                           @"BindingLSC": @((UInt8)([[Mapper instance] mapping][6])),
                           @"BindingRSC": @((UInt8)([[Mapper instance] mapping][7])),
                           @"BindingLB": @((UInt8)([[Mapper instance] mapping][8])),
                           @"BindingRB": @((UInt8)([[Mapper instance] mapping][9])),
                           @"BindingGuide": @((UInt8)([[Mapper instance] mapping][10])),
                           @"BindingA": @((UInt8)([[Mapper instance] mapping][11])),
                           @"BindingB": @((UInt8)([[Mapper instance] mapping][12])),
                           @"BindingX": @((UInt8)([[Mapper instance] mapping][13])),
                           @"BindingY": @((UInt8)([[Mapper instance] mapping][14])),
                           @"SwapSticks": @((BOOL)([_swapSticks state]==NSOnState)),
                           @"Pretend360": @((BOOL)pretend360)};

    // Set property
    IORegistryEntrySetCFProperties(registryEntry, (__bridge CFTypeRef)(dict));
    SetController(GetSerialNumber(registryEntry), dict);
}

// Run an AppleScript from String and returns YES on successful execution
- (BOOL)runInlineAppleScript:(NSString *)scriptString
{
    NSDictionary* errorDict;
    NSAppleEventDescriptor* returnDescriptor = NULL;

    NSAppleScript* scriptObject = [[NSAppleScript alloc] initWithSource:scriptString];

    returnDescriptor = [scriptObject executeAndReturnError: &errorDict];
    scriptObject = nil;

    if (returnDescriptor != NULL)
    {
        // successful execution
        if (kAENullEvent != [returnDescriptor descriptorType])
        {
            return YES;
            /* Uncomment this to handle the returned values */
//            // script returned an AppleScript result
//            if (cAEList == [returnDescriptor descriptorType])
//            {
//                // result is a list of other descriptors
//            }
//            else
//            {
//                // coerce the result to the appropriate ObjC type
//            }
        }
    }
    else
    {
        // no script result, handle error
        id val = [errorDict objectForKey:@"NSAppleScriptErrorRange"];
        if (!val) {
            NSLog(@"APPLESCRIPT ERROR:\n%@", errorDict);
        } else {
            NSRange r = [val rangeValue];
            NSMutableString *errorPoint = [NSMutableString stringWithString:scriptString];
            [errorPoint insertString:@"<---***" atIndex:r.location+r.length]; // end
            [errorPoint insertString:@"***ERROR_HERE--->" atIndex:r.location]; // start
            NSLog(@"APPLESCRIPT ERROR:\n%@"
                  @"\nERROR LOCATION:\n%@",
                  errorDict, errorPoint);
        }
    }
    return NO;
}

// Enable/disable the driver
// FIXME: currently only works after the controller is connected and loaded once.
// FIXME: will not uncheck the "Enabled" box if the prefpane is started with the driver disabled
- (IBAction)toggleDriverEnabled:(NSButton *)sender
{
    NSLog(@"Enable/disable driver stuff: will change state...");
    NSString *script = nil;

    // QUESTION: should I disable the daemon too?
    if (sender.state == NSOnState) {
        // The driver should be enabled
        NSLog(@"Will Enable Driver...");
        script =
            @"do shell script \"\
            cd \\\"/Library/Extensions\\\"\n\
            kextload \\\"360Controller.kext\\\"\n\
            \" with administrator privileges\n";

    } else if (sender.state == NSOffState) {
        // The driver should be disabled
        NSLog(@"Will Disable Driver...");
        [self powerOff:nil];
        [self stopDevice];

        script =
            @"do shell script \"\
            kextstat | grep 360Controller\n\
            if [ $? -eq 0 ]\n\
            then\n\
                kextunload -b \\\"com.mice.driver.Xbox360Controller\\\"\n\
            fi\n\
            \" with administrator privileges\n";
    }

    if (script != nil) {
        if ([self runInlineAppleScript:script]) {
            NSLog(@"...done!");
            sleep(1);
        }
    }

    [self updateDeviceList];
}

// Handle I/O Kit device add/remove
- (void)handleDeviceChange
{
    // Ideally, this function would make a note of the controller's Location ID, then
    // reselect it when the list is updated, if it's still in the list.
    [self updateDeviceList];
}

- (IBAction)powerOff:(id)sender
{
    FFEFFESCAPE escape = {0};

    if (ffDevice == 0) return;
    escape.dwSize=sizeof(escape);
    escape.dwCommand=0x03;
    FFDeviceEscape(ffDevice, &escape);
}

- (IBAction)startRemappingPressed:(id)sender {
    if (![[Mapper instance] active])
		[[Mapper instance] runWithButton:_remappingButton owner:self];
    else
		[[Mapper instance] runWithButton:_remappingButton owner:self];
		[[Mapper instance] cancelWithButton:_remappingButton owner:self];
}

- (IBAction)resetRemappingPressed:(id)sender {
    [_remappingButton setState:NSOffState];
    [[Mapper instance] resetWithOwner:self];
}

- (IBAction)pretend360Checked:(id)sender {
    [self changeSetting:NULL];
    [self performSelector:@selector(updateDeviceList) withObject:nil afterDelay:0.5];
}

@end

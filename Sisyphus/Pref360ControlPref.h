/*
    MICE Xbox 360 Controller driver for Mac OS X
    Copyright (C) 2006-2013 Colin Munro

    Pref360ControlPref.h - definition for the pref pane class

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

#include <IOKit/IOKitLib.h>
#include <IOKit/IOCFPlugIn.h>
#include <IOKit/hid/IOHIDLib.h>
#include <IOKit/hid/IOHIDKeys.h>
#include <ForceFeedback/ForceFeedback.h>

@class Mapper;
@class DeviceLister;

@interface Pref360ControlPref : NSObject

@property (weak) DeviceLister *deviceLister;

// About Tab
/* put About Tab's @properties here */

// Internal info
@property (readonly) mach_port_t masterPort;

- (void)eventQueueFired:(void*)sender withResult:(IOReturn)result;

- (void)handleDeviceChange;

- (void)powerOff:(id)sender;
- (void)selectDevice:(id)sender;
- (void)changeSetting:(id)sender;

@end

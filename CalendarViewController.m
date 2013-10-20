
//  Created by yaonphy on 12-11-13.
//  Copyright (c) 2012年 yang. All rights reserved.


#import "CalendarViewController.h"

#import "VRGCalendarView.h"

@interface CalendarViewController ()
{
      VRGCalendarView *_theCalendar;
}
@end

@implementation CalendarViewController

- (void)viewDidLoad
{
//      [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
       [self initNavItem];
       self.navigationItem.title = @"iWordsCalendar";
       _theCalendar = [VRGCalendarView sharedCalendar];
       _theCalendar.delegate=self;
    _theCalendar.frame = CGRectMake(0, 40, 320,350);
      [self.view addSubview:_theCalendar];
      
      
      
}
-(void)dealloc
{
      [super dealloc];
}
-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(int)month targetHeight:(float)targetHeight animated:(BOOL)animated {
      if (month==[[NSDate date] month]) {
            NSArray *dates = [NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:5], nil];
            [calendarView markDates:dates];
      }
}

-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date {
      NSLog(@"Selected date = %@",date);
}



- (void)viewDidUnload
{
      [super viewDidUnload];
      // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
      return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end

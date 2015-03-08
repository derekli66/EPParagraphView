//
//  ViewController.m
//  EPParagraphView
//
//  Created by LEE CHIEN-MING on 3/8/15.
//  Copyright (c) 2015 CHIENMING LEE. All rights reserved.
//

#import "ViewController.h"
#import "EPParagraphView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // setup paragraph attributes dictionaries
    
    UIColor *titleColor = [UIColor darkGrayColor];
    UIColor *textColor = [UIColor darkTextColor];
    
    UIFont *titleFont = [UIFont boldSystemFontOfSize: 18.0f];
    UIFont *textFont = [UIFont systemFontOfSize:16.0f];
    
    NSString *paragraph1 = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ";
    
    NSString *paragraph2 = @"Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";
    
    NSDictionary *firstTitle = @{ EPParagraphText : @"First Title",
                                  EPParagraphTextColor : titleColor,
                                  EPParagraphFont : titleFont,
                                  EPParagraphType : EPParagraphTypeTitle
                                  };
    
    NSDictionary *firstParagraph = @{ EPParagraphText : paragraph1,
                                      EPParagraphTextColor: textColor,
                                      EPParagraphFont : textFont,
                                      EPParagraphLineSpacing : @(1.2)
                                      };
    
    NSDictionary *secondTitle = @{ EPParagraphText : @"Second Title",
                                   EPParagraphTextColor : titleColor,
                                   EPParagraphFont : titleFont,
                                   EPParagraphType : EPParagraphTypeTitle
                                   };
    
    NSDictionary *secondParagraph = @{ EPParagraphText : paragraph2,
                                       EPParagraphTextColor: textColor,
                                       EPParagraphFont : textFont,
                                       EPParagraphLineSpacing : @(1.2)
                                       };
    
    NSArray *attributesArray = @[firstTitle, firstParagraph, secondTitle, secondParagraph];
    
    EPParagraphView *bigView = [EPParagraphView paragraphViewWithParagraphParameters:attributesArray
                                                                        titlePadding:5.0f
                                                                         bodyPadding:10.0f];
    
    CGRect paragraphRect = CGRectMake(10.0f, 50.0f, 300.0f, 300.0f);
    
    CGFloat height = [EPParagraphView paragraphHeightWithParagraphArray:attributesArray
                                                           titlePadding:5.0f
                                                            bodyPadding:10.0f
                                                                  frame:paragraphRect];
    paragraphRect.size.height = height;
    bigView.frame = paragraphRect;
    
    [self.containerView addSubview:bigView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

@end

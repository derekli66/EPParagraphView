//
//  EPParagraphView.h
//  EPParagraphView
//
//  Created by LEE CHIEN-MING on 1/1/14.
//  Copyright (c) 2014 Derek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"

/**
 Use to specify this parameter set for Body or for Title.
 */
static NSString *const EPParagraphType = @"EPParagraphType";

/**
 for instance, @{ kEPParagraphType : EPParagraphTypeTitle }
 */
static NSString *const EPParagraphTypeTitle = @"EPParagraphTypeTitle";
static NSString *const EPParagraphTypeBody = @"EPParagraphTypeBody";

/**
 EPParagraphFont is a key to store UIFont instance
 */
static NSString *const EPParagraphFont = @"EPParagraphFont";

/**
 EPParagraphTextColor is a key to store UIColor instance
 */
static NSString *const EPParagraphTextColor = @"EPParagraphTextColor";

/**
 EPParagraphText is a key to store NSString instance
 */
static NSString *const EPParagraphText = @"EPParagraphText";

/**
 Use EPParagraphLinkSet as a key store an array containing dicitonaries with EPParagraphLinkRange and EPParagraphLinkURL
 */
static NSString *const EPParagraphLinkSet = @"EPParagraphLinkSet";

/** 
    Use kEPParagraphLinkSet key to store a dictionary array
    In each dictionary, use EPParagraphLinkRange and EPParagraphLinkURL to store the string range and linked url

    for instance, NSDictionary *LinkDictionary = @{ kEPParagraphLinkRange : [NSValue valueFromRange:NSMakeRange(position, length)]
                     kEPParagraphLinkURL : [NSURL urlWithString:linkString]
                     }

    @[LinkDictionary01, LinkDictionary02, LinkDictionary03]
 */
static NSString *const EPParagraphLinkRange = @"EPParagraphLinkRange";
static NSString *const EPParagraphLinkURL = @"EPParagraphLinkURL";

/**
 kEPParagraphLineHeight to set line height value for each paragraph. The value must greater than 1.
 */
static NSString *const EPParagraphLineSpacing = @"EPParagraphLineSpacing";

@protocol EPParagraphViewDelegate;

@interface EPParagraphView : UIView <TTTAttributedLabelDelegate>

/**
 EPParagraphViewDelegate to receive touch event callbacks
 */
@property (nonatomic, weak) id<EPParagraphViewDelegate> delegate;

/**
 Get instance of EPParagraphView with paragraph parameter array and title padding/body padding
 With URL links
 
 @param paragraphArray array containing title and paragraph text attributes dictionaries
 @param aTitlePadding  bottom space for each Title
 @param aBodyPadding   bottom space for each paragraph body
 
 @return EPParagraphView instance
 */
+ (EPParagraphView *)paragraphViewWithParagraphParameters:(NSArray *)paragraphArray titlePadding:(CGFloat)aTitlePadding bodyPadding:(CGFloat)aBodyPadding;

/**
 Get instance of EPParagraphView with paragraph parameter array and title padding/body padding
 With URL links
 
 @param paragraphArray array containing title and paragraph text attributes dictionaries
 @param aTitlePadding  bottom space for each Title
 @param aBodyPadding   bottom space for each paragraph body
 
 @return EPParagraphView instance
 */
+ (EPParagraphView *)paragraphViewWithParagraphParametersAndScanURL:(NSArray *)paragraphArray titlePadding:(CGFloat)aTitlePadding bodyPadding:(CGFloat)aBodyPadding;

/**
 BOOL value to determine if URL links should be highlighted.
 */
@property (nonatomic) BOOL isScanURL;


/**
 Get the total height of EPParagraphView instance
 
 @param paragraphArray array containing title and paragraph text attributes dictionaries
 @param aTitlePadding  top space for each Title
 @param aBodyPadding   top space for each paragraph body
 @param aFrame         initial frame for paragraph view
 
 @return final frame height after calculation
 */
+ (CGFloat)paragraphHeightWithParagraphArray:(NSArray *)paragraphArray
                               titlePadding:(CGFloat)aTitlePadding
                                bodyPadding:(CGFloat)aBodyPadding
                                      frame:(CGRect)aFrame;

@end


@protocol EPParagraphViewDelegate <NSObject>
@optional
/**
 The delegate method will get called after user touches the URL link
 
 @param aParagraphView target paragraph view
 @param label          the TTTAttributedLabel instance with the URL link
 @param url            the selected URL link
 */
- (void)paragraphView:(EPParagraphView *)aParagraphView attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url;
@end

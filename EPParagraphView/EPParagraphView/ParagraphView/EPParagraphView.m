//
//  EPParagraphView.m
//  EPParagraphView
//
//  Created by LEE CHIEN-MING on 1/1/14.
//  Copyright (c) 2014 Derek. All rights reserved.
//

#import "EPParagraphView.h"

#define BAD_SOLUTION_ADJUSTMENT 0.2f

@interface EPParagraphView()
@property (nonatomic, strong) NSArray *paragraphParameterArray;
@property (nonatomic) CGFloat titlePadding;
@property (nonatomic) CGFloat bodyPadding;
@end

@implementation EPParagraphView
#pragma mark - Initialization
+ (EPParagraphView *)paragraphViewWithParagraphParameters:(NSArray *)paragraphArray titlePadding:(CGFloat)aTitlePadding bodyPadding:(CGFloat)aBodyPadding
{
    EPParagraphView *newView = [[EPParagraphView alloc] initWithFrame:CGRectZero
                                                       paragraphParameters:paragraphArray
                                                         titlePadding:aTitlePadding
                                                          bodyPadding:aBodyPadding];
    return newView;
}

+ (EPParagraphView *)paragraphViewWithParagraphParametersAndScanURL:(NSArray *)paragraphArray
                                                      titlePadding:(CGFloat)aTitlePadding
                                                       bodyPadding:(CGFloat)aBodyPadding
{
    EPParagraphView *newView = [[EPParagraphView alloc] initScanURLWithFrame:CGRectZero
                                                         paragraphParameters:paragraphArray
                                                                titlePadding:aTitlePadding
                                                                 bodyPadding:aBodyPadding];
    return newView;
}

- (id)initWithFrame:(CGRect)frame
    paragraphParameters:(NSArray *)paragraphArray
      titlePadding:(CGFloat)aTitlePadding
       bodyPadding:(CGFloat)aBodyPadding
{
    self = [super initWithFrame:frame];
    if (self) {
        _titlePadding = aTitlePadding;
        _titlePadding = (_titlePadding > 0) ? _titlePadding : 5.0f;
        _bodyPadding = aBodyPadding;
        _bodyPadding = (_bodyPadding > 0) ? _bodyPadding : 10.0f;
         _isScanURL = NO;
        
        self.paragraphParameterArray = paragraphArray;
        self.backgroundColor = [UIColor clearColor];
        
        //Create TTTAttributedLabel
        for (int i = 0; i < [paragraphArray count]; i++) {
            NSDictionary *dict = paragraphArray[i];
            TTTAttributedLabel *newLabel = [self createNewAttributedLabelWithParagraphParameter:dict];
            newLabel.tag = i + 100;
            [self addSubview:newLabel];
        }
    }
    return self;
}

-(id)initScanURLWithFrame:(CGRect)frame
      paragraphParameters:(NSArray *)paragraphArray
             titlePadding:(CGFloat)aTitlePadding
              bodyPadding:(CGFloat)aBodyPadding
{
    self = [super initWithFrame:frame];
    if (self) {
        _titlePadding = aTitlePadding;
        _titlePadding = (_titlePadding > 0) ? _titlePadding : 5.0f;
        _bodyPadding = aBodyPadding;
        _bodyPadding = (_bodyPadding > 0) ? _bodyPadding : 10.0f;
        _isScanURL = YES;
        
        self.paragraphParameterArray = paragraphArray;
        self.backgroundColor = [UIColor clearColor];
        
        //Create TTTAttributedLabel
        for (int i = 0; i < [paragraphArray count]; i++) {
            NSDictionary *dict = paragraphArray[i];
            TTTAttributedLabel *newLabel = [self createNewAttributedLabelWithParagraphParameter:dict];
            newLabel.tag = i + 100;
            [self addSubview:newLabel];
        }
    }
    return self;
}

-(TTTAttributedLabel *)createNewAttributedLabelWithParagraphParameter:(NSDictionary *)dictionary
{
    NSAssert([dictionary isKindOfClass:[NSDictionary class]], @"The input parameter dictionary inside paragraphArray is not NSDictionary class");
    
    TTTAttributedLabel *newLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    newLabel.delegate = self;
    newLabel.numberOfLines = 0;
    newLabel.backgroundColor = [UIColor clearColor];
    newLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
    
    if (dictionary[EPParagraphFont]) {
        NSAssert([dictionary[EPParagraphFont] isKindOfClass:[UIFont class]], @"The paramter for EPParagraphFont is not a UIFont instance");
        newLabel.font = dictionary[EPParagraphFont];
    }
    
    if (dictionary[EPParagraphTextColor]) {
        NSAssert([dictionary[EPParagraphTextColor] isKindOfClass:[UIColor class]], @"The parameter for EPParagraphTextColor is not a UIColor instance");
        newLabel.textColor = dictionary[EPParagraphTextColor];
    }
    
    CGFloat aLineHeight = [dictionary[EPParagraphLineSpacing] doubleValue];
    newLabel.lineHeightMultiple = (aLineHeight < 1) ? 1.0f : aLineHeight;

    if (dictionary[EPParagraphText]) {
        NSAssert([dictionary[EPParagraphText] isKindOfClass:[NSString class]], @"The parameter for EPParagraphText is not a NSString instance");
        newLabel.text = dictionary[EPParagraphText];
    }
    
    if (dictionary[EPParagraphLinkSet] && [dictionary[EPParagraphLinkSet] isKindOfClass:[NSArray class]]) {
        if ([dictionary[EPParagraphLinkSet] count] > 0) {
            for (NSDictionary *linkDict in dictionary[EPParagraphLinkSet]) {
                NSAssert([linkDict isKindOfClass:[NSDictionary class]], @"Parameter in paragraphLinkSet is not a NSDictionary instance");

                NSValue *rangeValue = linkDict[EPParagraphLinkRange];
                NSURL *linkURL = linkDict[EPParagraphLinkURL];
                newLabel.linkAttributes = @{[NSNumber numberWithInt:kCTUnderlineStyleNone] : (id)kCTUnderlineStyleAttributeName}; // remove link underline
                [newLabel addLinkToURL:linkURL withRange:[rangeValue rangeValue]];
            }
        }
    }
    else if(_isScanURL == YES){
        
        NSError *error = NULL;
        NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink
                                                                   error:&error];
        
        NSUInteger numberOfMatches = [detector numberOfMatchesInString:newLabel.text
                                                               options:0
                                                                 range:NSMakeRange(0, [newLabel.text length])];
        if ((unsigned long)numberOfMatches > 0) {
            
            NSArray *matches = [detector matchesInString:newLabel.text
                                                 options:0
                                                   range:NSMakeRange(0, [newLabel.text length])];
            for (NSTextCheckingResult *match in matches) {
                NSRange matchRange = [match range];
                NSString *urlString = [newLabel.text substringWithRange:matchRange];
                
                if ([match resultType] == NSTextCheckingTypeLink && ![urlString containsString:@"@"]) {
                    NSURL *url = [match URL];
                    [newLabel addLinkToURL:url withRange:matchRange];
                }
            }
        }
    }
    return newLabel;
}

#pragma mark - TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    
    if ([self.delegate respondsToSelector:@selector(paragraphView:attributedLabel:didSelectLinkWithURL:)]) {
        [self.delegate paragraphView:self attributedLabel:label didSelectLinkWithURL:url];
    }
}

#pragma mark - UIKit Methods
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if ([self.paragraphParameterArray count] > 0) {
        __block CGFloat accumulatedHeight = 0.0f;
        [self.paragraphParameterArray enumerateObjectsUsingBlock:^(NSDictionary *aDict, NSUInteger idx, BOOL *stop) {
            if (idx == 0) {
                accumulatedHeight = accumulatedHeight + self.titlePadding;
                
                TTTAttributedLabel *aLabel = (TTTAttributedLabel *)[self viewWithTag:idx + 100];
                CGRect newRect = [EPParagraphView fittingSizeWithText:aDict[EPParagraphText]
                                                      font:aDict[EPParagraphFont]
                                                lineHeight:aLabel.lineHeightMultiple
                                                     frame:self.frame];
                
                aLabel.frame = CGRectMake(0.0f, accumulatedHeight, newRect.size.width, newRect.size.height);
                if ([aDict[EPParagraphType] isEqualToString:EPParagraphTypeTitle]) {
                    accumulatedHeight = accumulatedHeight + newRect.size.height + self.titlePadding;
                }
                else {
                    accumulatedHeight = accumulatedHeight + newRect.size.height + self.bodyPadding;
                }
            }
            else{
                TTTAttributedLabel *aLabel = (TTTAttributedLabel *)[self viewWithTag:idx + 100];
                CGRect newRect = [EPParagraphView fittingSizeWithText:aDict[EPParagraphText]
                                                      font:aDict[EPParagraphFont]
                                                lineHeight:aLabel.lineHeightMultiple
                                                     frame:self.frame];
                
                aLabel.frame = CGRectMake(0.0f, accumulatedHeight, newRect.size.width, newRect.size.height);
                if (idx != [self.paragraphParameterArray count] - 1) {
                    if ([aDict[EPParagraphType] isEqualToString:EPParagraphTypeTitle]) {
                        accumulatedHeight = accumulatedHeight + newRect.size.height + self.titlePadding;
                    }
                    else {
                        accumulatedHeight = accumulatedHeight + newRect.size.height + self.bodyPadding;
                    }
                }
            }
        }];
    }
}

#pragma mark - Private Methods
+(CGRect)fittingSizeWithText:(NSString *)aStr font:(UIFont *)aFont lineHeight:(CGFloat)aLineHeight frame:(CGRect)aFrame
{
    if (aLineHeight < 1) {
        aLineHeight = 1.0f;
    }
    
    NSMutableParagraphStyle *paragraphStype = [[NSMutableParagraphStyle alloc] init];
    [paragraphStype setLineHeightMultiple:aLineHeight + BAD_SOLUTION_ADJUSTMENT];
    
    NSDictionary *attributed = @{ NSFontAttributeName : aFont,
                                  NSParagraphStyleAttributeName : paragraphStype
                                  };
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:aStr
                                                                           attributes:attributed];
    
   CGSize checkSize = [TTTAttributedLabel sizeThatFitsAttributedString:attributedString
                                            withConstraints:CGSizeMake(aFrame.size.width, CGFLOAT_MAX)
                                     limitedToNumberOfLines: 100000 ];
    
    return CGRectIntegral(CGRectMake(0.0f, 0.0f, checkSize.width, checkSize.height));
}

#pragma mark - Custom Methods
+(CGFloat)paragraphHeightWithParagraphArray:(NSArray *)paragraphArray
                               titlePadding:(CGFloat)aTitlePadding
                                bodyPadding:(CGFloat)aBodyPadding
                                      frame:(CGRect)aFrame
{
    aTitlePadding = (aTitlePadding > 0) ? aTitlePadding : 5.0f;
    aBodyPadding = (aBodyPadding > 0) ? aBodyPadding : 10.0f;
    
    __block CGFloat accumulatedHeight = 0.0f;

    if ([paragraphArray count] > 0) {
        [paragraphArray enumerateObjectsUsingBlock:^(NSDictionary *aDict, NSUInteger idx, BOOL *stop) {
            CGFloat aLineHeight = ([aDict[EPParagraphLineSpacing] doubleValue]) < 1.0f ? 1.0f : [aDict[EPParagraphLineSpacing] doubleValue];

            if (idx == 0) {
                accumulatedHeight += aTitlePadding;
            }
            
            CGRect newRect = [EPParagraphView fittingSizeWithText:aDict[EPParagraphText]
                                                             font:aDict[EPParagraphFont]
                                                       lineHeight:aLineHeight
                                                            frame:aFrame];
            
            if ([aDict[EPParagraphType] isEqualToString:EPParagraphTypeTitle]) {
                accumulatedHeight = accumulatedHeight + aTitlePadding + newRect.size.height;
            }
            else {
                accumulatedHeight = accumulatedHeight + aBodyPadding + newRect.size.height;
            }
        }];
    }
    
    return accumulatedHeight;
}

@end

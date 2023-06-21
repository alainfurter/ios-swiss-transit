//
//  MCMessageView.h
//  MCMessageView
//

/*
 License
 =======
 
 This code is distributed under the terms and conditions of the MIT license. 
 
 Copyright (c) 2011 Junior Bontognali
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */


#import <UIKit/UIKit.h>

typedef enum {
    /** Opacity animation */
    MCMessageViewAnimationFade,
    /** Opacity + scale animation */
    MCMessageViewAnimationZoom
} MCMessageViewAnimation;

@interface MCFlashMessageView : UIView {
	
    MCMessageViewAnimation animationType;
	
	BOOL useAnimation;
    BOOL autoHide;
	
    float yOffset;
    float xOffset;
	
	float width;
	float height;
	
	UILabel *label;
	UILabel *detailsLabel;
	
	NSString *labelText;
	NSString *detailsLabelText;
	float opacity;
	UIFont *labelFont;
	UIFont *detailsLabelFont;
	
    BOOL isFinished;
	BOOL removeFromSuperViewOnHide;
	
    float showtime;
    
    UIImageView *icon;
	
	CGAffineTransform rotationTransform;
}


- (id)initWithWindow:(UIWindow *)window;
- (id)initWithView:(UIView *)view;

@property (assign) MCMessageViewAnimation animationType;
@property (copy) NSString *labelText;
@property (copy) NSString *detailsLabelText;
@property (assign) float opacity;
@property (assign) float xOffset;
@property (assign) float yOffset;
@property (assign) float showtime;
@property (assign) BOOL removeFromSuperViewOnHide;
@property (assign) BOOL autoHide;
@property (retain) UIFont* labelFont;
@property (retain) UIFont* detailsLabelFont;
@property (retain) UIImageView *icon;


- (void)show:(BOOL)animated;
- (void)hide:(BOOL)animated;
- (void)hide;

@end

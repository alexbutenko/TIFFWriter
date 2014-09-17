//
//  ViewController.m
//  TIFFWriter
//
//  Created by alexbutenko on 9/17/14.
//  Copyright (c) 2014 alex. All rights reserved.
//

#import "ViewController.h"
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/UTCoreTypes.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIImage *img = [UIImage imageNamed:@"test_image.jpg"];
    
    float compression = 1.0; // Lossless compression if available.
    int orientation = 1; // Origin is at top, left.
    CFStringRef myKeys[3];
    CFTypeRef   myValues[3];
    CFDictionaryRef myOptions = NULL;
    myKeys[0] = kCGImagePropertyOrientation;
    myValues[0] = CFNumberCreate(NULL, kCFNumberIntType, &orientation);
    myKeys[1] = kCGImagePropertyHasAlpha;
    myValues[1] = kCFBooleanTrue;
    myKeys[2] = kCGImageDestinationLossyCompressionQuality;
    myValues[2] = CFNumberCreate(NULL, kCFNumberFloatType, &compression);
    myOptions = CFDictionaryCreate( NULL, (const void **)myKeys, (const void **)myValues, 3,
                                   &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"test_image.tiff"];
    
    [self writeCGImage:img.CGImage toURL:[NSURL fileURLWithPath:filePath] withType:kUTTypeTIFF andOptions:myOptions];
}

- (void) writeCGImage: (CGImageRef) image toURL: (NSURL*) url withType: (CFStringRef) imageType andOptions: (CFDictionaryRef) options
{
    CGImageDestinationRef myImageDest = CGImageDestinationCreateWithURL((CFURLRef)url, imageType, 1, nil);
    CGImageDestinationAddImage(myImageDest, image, options);
    CGImageDestinationFinalize(myImageDest);
    CFRelease(myImageDest);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

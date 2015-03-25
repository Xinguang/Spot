//
//  JSQVoiceMediaItem.h
//  spot
//
//  Created by 張志華 on 2015/03/24.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

#import "JSQMediaItem.h"

@interface JSQVoiceMediaItem : JSQMediaItem <JSQMessageMediaData, NSCoding, NSCopying>

@property (copy, nonatomic) UIImage *image;

/**
 *  The image for the photo media item. The default value is `nil`.
 */
@property (copy, nonatomic) NSData *voice;

/**
 *  Initializes and returns a photo media item object having the given image.
 *
 *  @param image The image for the photo media item. This value may be `nil`.
 *
 *  @return An initialized `JSQPhotoMediaItem` if successful, `nil` otherwise.
 *
 *  @discussion If the image must be dowloaded from the network,
 *  you may initialize a `JSQPhotoMediaItem` object with a `nil` image.
 *  Once the image has been retrieved, you can then set the image property.
 */
- (instancetype)initWithVoice:(NSData *)data image:(UIImage *)image;

@end

//
//  Customer.m
//  JDZ
//
//  Created by apple on 16/7/22.
//  Copyright (c) 2016年 apple. All rights reserved.
//

#import "Customer.h"
#import <ifaddrs.h>
#import <arpa/inet.h>

@implementation Customer

static NSString * const kRHDictionaryKey = @"com.xxxx.dictionaryKey";
static NSString * const kRHKeyChainKey = @"com.xxxx.keychainKey";



//获取IP
+(NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}


//判断手机号
+(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}



+ (NSString *)YB_Date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    return dateString;
}
//签名
+(NSString *)initWithTime:(NSString *)time nonce:(NSString *)once{
    
    NSString * str =[NSString md5To32bit:once];
    NSArray * array=@[@"soft",@"sync",time,str];
    NSArray * result =[array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        return [obj1 compare:obj2];
    }];
    NSString * sign =[NSString sha1:[[result componentsJoinedByString:@","] stringByReplacingOccurrencesOfString:@"," withString:@""]];
    
//        NSLog(@"sign>>%@",[[result componentsJoinedByString:@","] stringByReplacingOccurrencesOfString:@"," withString:@""]);
    
    return sign;
}

//获取时间戳
+(NSString *)timeString{

    NSTimeInterval a=[[NSDate date] timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
    
    
    return timeString;
}
//随机字符串
+(NSString *)once{
     NSMutableArray * shuffledAlphabet = [NSMutableArray arrayWithArray:@[@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z"]];
    NSMutableArray * arr =[NSMutableArray new];
    for (int i=0; i<6; i++) {
        int a=arc4random()%6;
        NSString * str =shuffledAlphabet[a];
        [arr addObject:str];
    }
    NSString * once =[[arr componentsJoinedByString:@","] stringByReplacingOccurrencesOfString:@"," withString:@""];
    return once;
}
//裁剪图片
+ (UIImage *)cutImage:(UIImage*)image rect:(CGRect)rect
{
    //压缩图片
    CGSize newSize;
    CGImageRef imageRef = nil;
    
    if ((image.size.width / image.size.height) < (rect.size.width / rect.size.height)) {
        newSize.width = image.size.width;
        newSize.height = image.size.width * rect.size.height / rect.size.width;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, fabs(image.size.height - newSize.height) / 2, newSize.width, newSize.height));
        
    } else {
        newSize.height = image.size.height;
        newSize.width = image.size.height * rect.size.width / rect.size.height;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(fabs(image.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));
        
    }
    
    return [UIImage imageWithCGImage:imageRef];
}
//改变行间距
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space {
    
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
    
}
+ (NSString *)encodeParameter:(NSString *)originalPara {
    CFStringRef encodeParaCf = CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)originalPara, NULL, CFSTR("!*'();:@&=+$,/?%#[] "), kCFStringEncodingUTF8);
    NSString *encodePara = (__bridge NSString *)(encodeParaCf);
    CFRelease(encodeParaCf);
    return encodePara;
}


+(BOOL)TokenRefreshWithTime:(NSString *)expiredTime{
    //    [defaults objectForKey:@"expired_at"]

    if(expiredTime!=NULL){
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [dateFormatter dateFromString:expiredTime];
        NSTimeInterval a=[date timeIntervalSince1970]*1000;
        NSString *time = [NSString stringWithFormat:@"%.0f", a];
        
        NSLog(@"%@--%@",time,[self timeString]);
        
        if ([time longLongValue]>[[self timeString] longLongValue]) {
            
            return NO;
            
        }else{
            
            return YES;
        }
        
    }else{
        
        return YES;
    }
    
    
}
+ (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}


+(ShopModel *)ModelWithShop:(Shop *)shop{
    
    ShopModel * model =[[ShopModel alloc]init];
    model.title=shop.title;
    model.shoujia=shop.shoujia;
    model.yhPrice=shop.yhPrice;
    model.quanhou=shop.quanhou;
    model.tmall=shop.urlContent;
    
    model.thumb=shop.thumb;
    
    return model;
    
}

//view转image
+ (UIImage *)createViewImage:(ShopModel *)model {
    
    
    UIView * shareView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOWRECT_WIDTH, WINDOWRECT_WIDTH+130)];
    shareView.backgroundColor=[UIColor whiteColor];
    
    UIImageView * imageView =[[UIImageView alloc]init];
    imageView.image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.thumb]]];
    //    [imageView sd_setImageWithURL:[NSURL URLWithString:model.thumb]];
    [shareView addSubview:imageView];
    
    NSString * url =[NSString stringWithFormat:@"http://www.55ye.com/cms/href?url=%@",model.tmall];
    UIImage * qrcode = [self createNonInterpolatedUIImageFormCIImage:[self createQRForString:url] withSize:100.0f];
    
    UIImageView * bgImage=[[UIImageView alloc]init];
    bgImage.image=[UIImage imageNamed:@"ju"];
    [shareView addSubview:bgImage];
    
    UIImageView * codeImg =[[UIImageView alloc]init];
    codeImg.image=qrcode;
    [bgImage addSubview:codeImg];
    
    UILabel * lab =[[UILabel alloc]init];
    lab.text=@"长按识别二维码";
    lab.font=[UIFont systemFontOfSize:10];
    lab.textAlignment=NSTextAlignmentCenter;
    lab.textColor=UIColorFromRGB(0xff486c);
    [shareView addSubview:lab];
    
    UILabel * titLab =[[UILabel alloc] init];
    titLab.text=[NSString stringWithFormat:@"            %@",model.title];
    titLab.font=[UIFont systemFontOfSize:12];
    titLab.textColor=UIColorFromRGB(0x333333);
    titLab.numberOfLines=0;
    [shareView addSubview:titLab];
    
    UILabel * byLab =[[UILabel alloc]init];
    byLab.backgroundColor=UIColorFromRGB(0xff486c);
    byLab.text=@"包邮";
    byLab.textAlignment=NSTextAlignmentCenter;
    byLab.textColor=[UIColor whiteColor];
    byLab.font=[UIFont systemFontOfSize:12];
    byLab.layer.masksToBounds=YES;
    byLab.layer.cornerRadius=8;
    [shareView addSubview:byLab];
    
    

    
    imageView.sd_layout
    .topSpaceToView(shareView, 0)
    .leftSpaceToView(shareView, 0)
    .rightSpaceToView(shareView, 0)
    .heightIs(WINDOWRECT_WIDTH);
    
    bgImage.sd_layout
    .topSpaceToView(imageView, 10)
    .rightSpaceToView(shareView, 10)
    .heightIs(90)
    .widthIs(90);
    
    codeImg.sd_layout
    .centerXEqualToView(bgImage)
    .centerYEqualToView(bgImage)
    .heightIs(85)
    .widthIs(85);
    
    lab.sd_layout
    .topSpaceToView(bgImage, 2)
    .rightEqualToView(bgImage)
    .heightIs(14)
    .widthIs(90);
    
    titLab.sd_layout
    .topSpaceToView(imageView, 10)
    .leftSpaceToView(shareView, 10)
    .rightSpaceToView(bgImage, 10)
    .autoHeightRatio(0);
    
    byLab.sd_layout
    .topSpaceToView(imageView, 8)
    .leftSpaceToView(shareView, 10)
    .widthIs(34)
    .heightIs(16);
    
    
    if ([model.shoujia intValue]==0) {
        
        UILabel * priceLab =[[UILabel alloc]init];
        priceLab.textAlignment=NSTextAlignmentLeft;
        priceLab.text=[NSString stringWithFormat:@"价格:￥%.2f",[model.shoujia floatValue]];
        priceLab.font=[UIFont systemFontOfSize:12];
        priceLab.textColor=UIColorFromRGB(0xff486c);
        [shareView addSubview:priceLab];

        priceLab.sd_layout
        .topSpaceToView(titLab, 5)
        .leftEqualToView(titLab)
        .rightEqualToView(titLab)
        .heightIs(18);


    }else{
        
        UILabel * qhLab =[[UILabel alloc]init];
        qhLab.textColor=UIColorFromRGB(0xff486c);
        qhLab.font=[UIFont systemFontOfSize:11];
        qhLab.textAlignment=NSTextAlignmentLeft;
        NSString * qhStr =[NSString stringWithFormat:@"￥%.2f券后价",[model.quanhou floatValue]];
        NSUInteger length = [qhStr length];
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:qhStr];
        [AttributedStr addAttribute:NSFontAttributeName
         
                              value:[UIFont systemFontOfSize:14]
         
                              range:NSMakeRange(1, length-4)];
        
        qhLab.attributedText=AttributedStr;
        [shareView addSubview:qhLab];
        
        CGSize size =[qhStr sizeWithAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14] }];
        
        
        UILabel * priceLab =[[UILabel alloc]init];
        priceLab.textAlignment=NSTextAlignmentLeft;
        priceLab.text=[NSString stringWithFormat:@"￥%.2f",[model.shoujia floatValue]];
        priceLab.font=[UIFont systemFontOfSize:12];
        priceLab.textColor=UIColorFromRGB(0x333333);
        [shareView addSubview:priceLab];
        
        UIButton * qBtn=[UIButton new];
        [qBtn setTitle:@"券" forState:UIControlStateNormal];
        [qBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        qBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        [qBtn setBackgroundImage:[UIImage imageNamed:@"background_quan1"] forState:UIControlStateNormal];
        [shareView addSubview:qBtn];
        
        NSString * yhStr =[NSString stringWithFormat:@"%.2f元",[model.yhPrice floatValue]];
        UIButton * qPBtn=[UIButton new];
        [qPBtn setTitle:yhStr forState:UIControlStateNormal];
        [qPBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        qPBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        [qPBtn setBackgroundImage:[UIImage imageNamed:@"background_quan2"] forState:UIControlStateNormal];
        [shareView addSubview:qPBtn];
        CGSize size1 =[yhStr sizeWithAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14] }];
        
        
        qhLab.sd_layout
        .topSpaceToView(titLab, 5)
        .leftSpaceToView(shareView, 10)
        .heightIs(18)
        .widthIs(size.width);
        
        priceLab.sd_layout
        .topSpaceToView(titLab, 5)
        .leftSpaceToView(qhLab, 0)
        .rightEqualToView(titLab)
        .heightIs(18);
        
        qBtn.sd_layout
        .topSpaceToView(qhLab, 10)
        .leftSpaceToView(shareView, 10)
        .heightIs(20)
        .widthIs(20);
        
        qPBtn.sd_layout
        .topSpaceToView(qhLab, 10)
        .leftSpaceToView(qBtn, 0)
        .heightIs(20)
        .widthIs(size1.width+4);
    }
    
    
    UIGraphicsBeginImageContextWithOptions(shareView.bounds.size, NO, [UIScreen mainScreen].scale);
    [shareView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent),size/CGRectGetHeight(extent));
    // create a bitmap image that we'll draw into a bitmap context at the desired size;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // Create an image with the contents of our bitmap
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    // Cleanup
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

+(CIImage *)createQRForString:(NSString *)qrString {
    // Need to convert the string to a UTF-8 encoded NSData object
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    // Create the filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    // Send the image back
    return qrFilter.outputImage;
}



@end

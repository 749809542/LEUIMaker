//
//  LEViewAdditions.m
//  LEUIMaker
//
//  Created by emerson larry on 2016/11/1.
//  Copyright © 2016年 LarryEmerson. All rights reserved.
//

#import "LEViewAdditions.h"
#pragma mark LEViewType
/** View的类型 */
typedef NS_ENUM(NSInteger, LEViewType) {
    /** 普通View */
    LENormalView = 0,
    /** 自动根据子View排版计算自身大小并排版 */
    LEWrapperView = 1,
    /** 纵向栈 */
    LEVerticalStack =2,
    /** 横向栈 */
    LEHorizontalStack=3,
    /** ScrollView自动根据子View计算ContentSize */
    LEAutoResizeContentView=4,
    /** 自动根据子View计算高度 */
    LEAutoCalcHeight=5,
    
};
#pragma mark LEViewAdditions
/** 给每个View动态添加的变量，用于存放位置信息实体 */
@interface LEViewAdditions : NSObject
#pragma mark LEViewAdditions View
/** 当前实体的拥有者的类型 */
@property (nonatomic) LEViewType viewType;
/** 当viewType为纵向或横向栈的时候，可设定栈的排版方式，默认为Center居中排版 */
@property (nonatomic) LEStackAlignment stackAlignment;
/** 当前实体的拥有者 */
@property (nonatomic, weak) UIView *ownerView;
/** 把当前View作为参照View的view列表，用于当前View变动后通知相关View重新排版 */
@property (nonatomic) NSMutableArray *related;
/** 当前View的父view */
@property (nonatomic, weak) UIView *superView;
/** 当前View的参照View，可以是父view或者同父的view */
@property (nonatomic, weak) UIView *relativeView;
/** 当前View的锚点 */
@property (nonatomic) LEAnchors leAnchor;
/** 当前View的间距：上 */
@property (nonatomic) CGFloat topMargin;
/** 当前View的间距：左 */
@property (nonatomic) CGFloat leftMargin;
/** 当前View的间距：下 */
@property (nonatomic) CGFloat bottomMargin;
/** 当前View的间距：右 */
@property (nonatomic) CGFloat rightMargin;
/** 当前View的宽 */
@property (nonatomic) CGFloat width;
/** 当前View的高 */
@property (nonatomic) CGFloat height;
/** 当前View的最大宽 */
@property (nonatomic) CGFloat maxWidth;
/** 当前View的最大高 */
@property (nonatomic) CGFloat maxHeight;

/** 当前View的最大宽相对于屏幕宽的差值 */
@property (nonatomic) CGFloat marginForMaxWidth;

/** 宽度等于superView宽度比 */
@property (nonatomic) CGFloat equalSuperViewWidth;
/** 高度等于superView高度比 */
@property (nonatomic) CGFloat equalSuperViewHeight;
/** 宽度等于relativeView宽度比 */
@property (nonatomic) CGFloat equalRelativeViewWidth;
/** 高度等于relativeView高度比 */
@property (nonatomic) CGFloat equalRelativeViewHeight;
/** 高度等于superView宽度比 */
@property (nonatomic) CGFloat heightEqualSuperViewWidth;
/** 高度等于relativeView宽度比 */
@property (nonatomic) CGFloat heightEqualRelativeViewWidth;
/** 宽度等于高度比 */
@property (nonatomic) CGFloat widthEqualHeight;
/** 高度等于宽度比 */
@property (nonatomic) CGFloat heightEqualWidth;
/** 间距上的高度比 */
@property (nonatomic) CGFloat topEqualHeight;
/** 间距下的高度比 */
@property (nonatomic) CGFloat bottomEqualHeight;
/** 间距左的宽度比 */
@property (nonatomic) CGFloat leftEqualWidth;
/** 间距下的宽度比 */
@property (nonatomic) CGFloat rightEqualWidth;
/** 是否是自动缩放容器 */
@property (nonatomic) BOOL isAutoResizeContentView;
/** 按钮的文字 */
@property (nonatomic) NSString *uiText;
#pragma mark LEViewAdditions Label
/** Label的行间距 */
@property (nonatomic) float lineSpace;
#pragma mark LEViewAdditions Button
/** 按钮的固定宽和高，不对内容变动而变动，可分别设定宽或高 */
@property (nonatomic) CGSize fixedButtonSize;
/** 按钮的内边距，可分别设定纵向及横向 */
@property (nonatomic) CGSize buttonContentInsects;
/** 按钮垂直排版 */
@property (nonatomic) BOOL isButtonVerticalLayout;

@property (nonatomic) BOOL isIgnoreTouchEventLock;
@end

@interface UIView (LEAddition)
/** 每个View动态懒添加的位置信息实体 */
@property (nonatomic) LEViewAdditions *leViewAdditions;
@end

@implementation LEViewAdditions
#pragma mark getFrame
-(CGRect) leGetFrame{
    LEAnchors anchor=self.leAnchor;
    CGRect frame=CGRectZero;
#pragma mark t,l,b,r,w,h,sw,sh,rw,rh
    float t=self.topMargin;
    float l=self.leftMargin;
    float b=self.bottomMargin;
    float r=self.rightMargin;
    float w=0;
    float h=0;
    float sw=0,sh=0,rw=0,rh=0;
    if([self.ownerView isKindOfClass:[UIButton class]]){
        w=self.fixedButtonSize.width;
        h=self.fixedButtonSize.height;
        if(w==0)w=self.width;
        if(h==0)h=self.height;
    }else{
        w=self.width;
        h=self.height;
    }
    if(self.superView){
        sw=self.superView.bounds.size.width;
        sh=self.superView.bounds.size.height;
        if(self.equalSuperViewWidth>0){
            w=sw*self.equalSuperViewWidth;
        }
        if(self.equalSuperViewHeight>0){
            h=sh*self.equalSuperViewHeight;
        }
        if(self.heightEqualSuperViewWidth>0){
            h=sw*self.heightEqualSuperViewWidth;
        }
    }
    if(self.relativeView){
        rw=self.relativeView.bounds.size.width;
        rh=self.relativeView.bounds.size.height;
        if(self.equalRelativeViewWidth>0){
            w=rw*self.equalSuperViewWidth;
        }
        if(self.equalRelativeViewHeight>0){
            h=rh*self.equalSuperViewWidth;
        }
        if(self.heightEqualRelativeViewWidth>0){
            h=rw*self.heightEqualRelativeViewWidth;
        }
    }
    if(self.widthEqualHeight>0){
        w=h*self.widthEqualHeight;
    }else if(self.heightEqualWidth>0){
        h=w*self.heightEqualWidth;
    }
    if(self.leftEqualWidth>0){
        l=sw*self.leftEqualWidth;
    }
    if(self.rightEqualWidth>0){
        r=sw*self.rightEqualWidth;
    }
    if(self.topEqualHeight>0){
        t=sh*self.topEqualHeight;
    }
    if(self.bottomEqualHeight>0){
        b=sh*self.bottomEqualHeight;
    }
    float offCX=l-r;
    float offCY=t-b;
#pragma mark Inside
    BOOL isSuperViewAsWrapper=self.superView.leViewAdditions.viewType==LEWrapperView;;
    if(anchor==LEAnchorNone){
        if(!isSuperViewAsWrapper&&w==0&&h==0){
            frame=CGRectMake(l, t, sw-l-r, sh-t-b);
        }else{
            frame=CGRectMake(l, t, w, h);
        }
    }else if(anchor<LEOutside1){
        switch (anchor) {
            case LEInsideTopLeft:
                frame=CGRectMake(l, t, w, h);
                break;
            case LEInsideTopCenter:
                w=(!isSuperViewAsWrapper&&w==0?sw-l-r:w);
                if(self.heightEqualWidth>0){
                    h=w*self.heightEqualWidth;
                }
                frame=CGRectMake((sw-w)*0.5+offCX, t, w, h);
                break;
            case LEInsideTopRight:
                frame=CGRectMake(sw-w-r, t, w, h);
                break;
            case LEInsideLeftCenter:
                h=(!isSuperViewAsWrapper&&h==0?sh-t-b:h);
                if(self.widthEqualHeight>0){
                    w=h*self.widthEqualHeight;
                }
                frame=CGRectMake(l, (sh-h)*0.5+offCY, w, h);
                break;
            case LEInsideCenter:
                w=(!isSuperViewAsWrapper&&w==0?sw-l-r:w);
                h=(!isSuperViewAsWrapper&&h==0?sh-t-b:h);
                if(self.widthEqualHeight>0){
                    w=h*self.widthEqualHeight;
                }else if(self.heightEqualWidth>0){
                    h=w*self.heightEqualWidth;
                }
                frame=CGRectMake(offCX+(sw-w)*0.5, offCY+(sh-h)*0.5, w, h);
                break;
            case LEInsideRightCenter:
                h=(!isSuperViewAsWrapper&&h==0?sh-t-b:h);
                if(self.widthEqualHeight>0){
                    w=h*self.widthEqualHeight;
                }
                frame=CGRectMake(sw-w-r, (sh-h)*0.5+offCY, w, h);
                break;
            case LEInsideBottomLeft:
                frame=CGRectMake(l, sh-h-b, w, h);
                break;
            case LEInsideBottomCenter:
                w=(!isSuperViewAsWrapper&&w==0?sw-l-r:w);
                if(self.heightEqualWidth>0){
                    h=w*self.heightEqualWidth;
                }
                frame=CGRectMake(offCX+(sw-w)*0.5, sh-h-b, w, h);
                break;
            case LEInsideBottomRight:
                frame=CGRectMake(sw-w-r, sh-h-b, w, h);
                break;
            default:
                break;
         }
    }else {
#pragma mark Outside
        float x=0;
        float y=0;
        if(self.relativeView){
              x=self.relativeView.frame.origin.x;
              y=self.relativeView.frame.origin.y;
        }else{
            rw=sw;
            rh=sh;
        }
        switch (anchor) {
            case LEOutside1:
                frame=CGRectMake(x-r-w, y-b-h, w, h);
                break;
            case LEOutside2:
                frame=CGRectMake(x+rw+l, y-b-h, w, h);
                break;
            case LEOutside3:
                frame=CGRectMake(x-r-w, y+rh+t, w, h);
                break;
            case LEOutside4:
                frame=CGRectMake(x+rw+l, y+rh+t, w, h);
                break;
            case LEOutsideTopLeft:
                frame=CGRectMake(x+l, y-b-h, w, h);
                break;
            case LEOutsideTopCenter:
                frame=CGRectMake(x+(rw-w)*0.5+offCX, y-b-h, w, h);
                break;
            case LEOutsideTopRight:
                frame=CGRectMake(x+rw-r-w, y-b-h, w, h);
                break;
            case LEOutsideLeftTop:
                frame=CGRectMake(x-w-r, y+t, w, h);
                break;
            case LEOutsideLeftCenter:
                frame=CGRectMake(x-w-r, y+(rh-h)*0.5+offCY, w, h);
                break;
            case LEOutsideLeftBottom:
                frame=CGRectMake(x-w-r, y+rh-b-h, w, h);
                break;
            case LEOutsideRightTop:
                frame=CGRectMake(x+rw+l, y+t, w, h);
                break;
            case LEOutsideRightCenter:
                frame=CGRectMake(x+rw+l, y+(rh-h)*0.5+offCY, w, h);
                break;
            case LEOutsideRightBottom:
                frame=CGRectMake(x+rw+l, y+rh-h-b, w, h);
                break;
            case LEOutsideBottomLeft:
                frame=CGRectMake(x+l, y+rh+t, w, h);
                break;
            case LEOutsideBottomCenter:
                frame=CGRectMake(x+(rw-w)*0.5+offCX, y+rh+t, w, h);
                break;
            case LEOutsideBottomRight:
                frame=CGRectMake(x+rw-w-r, y+rh+t, w, h);
                break;
            default:
                break;
        } 
    }
    return frame;
}
-(id) initWithOwner:(__kindof UIView *) owner{
    self=[super init];
    self.ownerView=owner;
    return self;
}
-(NSMutableArray *) related{
    if(!_related){
        _related=[NSMutableArray new];
    }
    return _related;
}
-(void) addRelated:(UIView *) view{
    LEWeakReferenceWrapper *obj=[LEWeakReferenceWrapper leWrapNonretainedObject:view.leViewAdditions];
    if(![self.related containsObject:obj]){
        [self.related addObject:obj];
    }
}
-(void) removeRelated:(UIView *) view{
    [self.related removeObject:view.leViewAdditions];
}
-(UIView *) popView{
    NSArray *array=self.ownerView.subviews;
    NSInteger counter=0;
    UIView *v=nil;
    UIView *last=self.ownerView;
    for (NSInteger i=0; i<array.count; i++) {
        if(v){
            last=v;
        }
        UIView *tmp=[array objectAtIndex:i];
        if(tmp.leViewAdditions.superView){
            v=tmp;
            counter++;
        }
    }
    if(v){
        [v leRelease];
        v=nil;
        if(counter-1==0){
            self.width=0;
            self.height=0;
        }
    }
    return last;
}
//-(void) dealloc{
//    NSLog(@"dealloc Additions");
//}
@end
@implementation UIView (LEAdditions)
//-(void) dealloc{
//    NSLog(@"dealloc View");
//}
-(void) leUpdateLayout{
    [self leAutoLayout];
}
-(void) leRelease{
    if(self.leViewAdditions){
        if(self.leViewAdditions.relativeView){
            [self.leViewAdditions.relativeView.leViewAdditions removeRelated:self];
        }
        if(self.leViewAdditions.related){
            [self.leViewAdditions.related removeAllObjects];
        }
        
    }
    self.leViewAdditions=nil;
    [self removeFromSuperview];
}
-(__kindof UIView *(^)(UIView *)) leAddTo{
    return ^id(UIView *value){
        [value addSubview:self];
        if(value.leViewAdditions.viewType==LEWrapperView||value.leViewAdditions.viewType==LEVerticalStack||value.leViewAdditions.viewType==LEHorizontalStack){//wrapper ,vs, hs
            [self.leViewAdditions addRelated:value];
        }
        self.leViewAdditions.superView=value;
        return self;
    };
}
-(__kindof UIView *(^)(UIView *)) leRelativeTo{
    return ^id(UIView *value){
        if(self.leViewAdditions.relativeView&&![self.leViewAdditions.relativeView isEqual:value]){
            [self.leViewAdditions.relativeView.leViewAdditions removeRelated:self];
        } 
        [value.leViewAdditions addRelated:self];
        self.leViewAdditions.relativeView=value;
        return self;
    };
}
-(__kindof UIView *(^)(LEAnchors)) leAnchor{
    return ^id(LEAnchors value){
        self.leViewAdditions.leAnchor=value;
        return self;
    };
}
-(__kindof UIView *(^)(CGFloat)) leTop{
    return ^id(CGFloat value){
        self.leViewAdditions.topMargin=value;
        [self leAutoLayout];
        return self;
    };
}
-(__kindof UIView *(^)(CGFloat)) leLeft{
    return ^id(CGFloat value){
        self.leViewAdditions.leftMargin=value;
        [self leAutoLayout];
        return self;
    };
}
-(__kindof UIView *(^)(CGFloat)) leBottom{
    return ^id(CGFloat value){
        self.leViewAdditions.bottomMargin=value;
        [self leAutoLayout];
        return self;
    };
}
-(__kindof UIView *(^)(CGFloat)) leRight{
    return ^id(CGFloat value){
        self.leViewAdditions.rightMargin=value;
        [self leAutoLayout];
        return self;
    };
}
-(__kindof UIView *(^)(UIEdgeInsets)) leMargins{
    return ^id(UIEdgeInsets value){
        self.leViewAdditions.topMargin=value.top;
        self.leViewAdditions.leftMargin=value.left;
        self.leViewAdditions.bottomMargin=value.bottom;
        self.leViewAdditions.rightMargin=value.right;
        [self leAutoLayout];
        return self;
    };
}
-(__kindof UIView *(^)(CGFloat)) leWidth{
    return ^id(CGFloat value){
        self.leViewAdditions.width=value;
        [self leAutoLayout];
        return self;
    };
}
-(__kindof UIView *(^)(CGFloat)) leHeight{
    return ^id(CGFloat value){
        self.leViewAdditions.height=value;
        [self leAutoLayout];
        return self;
    };
}
-(__kindof UIView *(^)(CGSize)) leSize{
    return ^id(CGSize value){
        self.leViewAdditions.width=value.width;
        self.leViewAdditions.height=value.height;
        [self leAutoLayout];
        return self;
    };
}
-(__kindof UIView *(^)(UIColor *)) leBgColor{
    return ^id(UIColor *value){
        self.backgroundColor=value;
        return self;
    };
}
-(__kindof UIView *(^)(BOOL)) leEnableTouch{
    return ^id(BOOL value){
        self.userInteractionEnabled=value;
        return self;
    };
}
-(__kindof UIView *(^)(SEL sel, id target)) leTouchEvent{
    return ^id(SEL sel, id target){
        if([self isKindOfClass:[UIButton class]]){
            UIButton *view=(UIButton *)self;
            [view addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
        }else if([self isKindOfClass:[UISwitch class]]){
            UISwitch *view=(UISwitch *)self;
            [view addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
        }else{
            if([target respondsToSelector:@selector(setUserInteractionEnabled:)]){
                [target setUserInteractionEnabled:YES];
            }
            [self setUserInteractionEnabled:YES];
            [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:target action:sel]];
        }
        return self;
    };
}
-(__kindof UIView *(^)(CGFloat)) leCorner{
    return ^id(CGFloat value){
        [self.layer setCornerRadius:value];
        [self.layer setMasksToBounds:YES];
        return self;
    };
}
-(__kindof UIView *(^)(CGFloat width, UIColor *color)) leBoard{
    return ^id(CGFloat width, UIColor *color){
        self.layer.borderWidth=width;
        self.layer.borderColor=color.CGColor;
        return self;
    };
}
-(void) onSetViewTypeWith:(LEViewType ) type{
    if(self.leViewAdditions.viewType==type){
        return;
    }
    NSAssert(self.leViewAdditions.viewType==0, @"View的类型是固定的，不可更换");
    self.leViewAdditions.viewType=type;
}
-(__kindof UIView *(^)()) leWrapper{
    return ^id(){
        [self onSetViewTypeWith:LEWrapperView];
        return self;
    };
}
-(__kindof UIView *(^)()) leStackAlignmnet{
    return ^id(LEStackAlignment value){
        self.leViewAdditions.stackAlignment=value;
        return self;
    };
}
#pragma Stacks (Vertical & Horizontal)
-(__kindof UIView *(^)()) leVerticalStack{
    return ^id(){
        [self onSetViewTypeWith:LEVerticalStack];
        return self;
    };
}
-(__kindof UIView *(^)()) leHorizontalStack{
    return ^id(){
        [self onSetViewTypeWith:LEHorizontalStack];
        return self;
    };
}
-(__kindof UIView *(^)()) leAutoResizeContentView{
    return ^id(){
        [self onSetViewTypeWith:LEAutoResizeContentView];
        return self;
    };
}
-(__kindof UIView *(^)()) leAutoCalcHeight{
    return ^id(){
        [self onSetViewTypeWith:LEAutoCalcHeight];
        return self;
    };
}
-(void) lePushToStack:(__kindof UIView *) view,...{
    NSAssert(self.leViewAdditions.viewType==LEVerticalStack||self.leViewAdditions.viewType==LEHorizontalStack||self.leViewAdditions.viewType==LEAutoResizeContentView, @"请先设定当前View的类型为栈类型（leVerticalStack，leHorizontalStack，LEHorizontalStackAutoResizeContentView），再入栈子View");
    NSMutableArray *muta=[NSMutableArray new];
    if(view){
        [muta addObject:view];
    }
    va_list params;
    va_start(params,view);
    id arg;
    if (view) {
        while( (arg = va_arg(params, __kindof UIView *)) ) {
            if ( arg ){
                [muta addObject:arg];
            }
        }
        va_end(params);
    }
    UIView *last=self;
    NSArray *sbvs=self.subviews;
    for (NSInteger i=sbvs.count-1; i>=0;i--) {
        UIView *v=[self.subviews objectAtIndex:i];
        if(v.leViewAdditions.superView){
            last=v;
            break;
        }
    }
    LEAnchors anchor1=self.leViewAdditions.viewType==LEVerticalStack?LEInsideTopCenter:LEInsideLeftCenter;
    LEAnchors anchor2=self.leViewAdditions.viewType==LEVerticalStack?LEOutsideBottomCenter:LEOutsideRightCenter;
    if(self.leViewAdditions.viewType==LEVerticalStack){
        if(self.leViewAdditions.stackAlignment==LELeftAlign){
            anchor1=LEInsideTopLeft;
            anchor2=LEOutsideBottomLeft;
        }else if(self.leViewAdditions.stackAlignment==LERightAlign){
            anchor1=LEInsideTopRight;
            anchor2=LEOutsideBottomRight;
        }
    }else{
        if(self.leViewAdditions.stackAlignment==LETopAlign){
            anchor1=LEInsideTopLeft;
            anchor2=LEOutsideRightTop;
        }else if(self.leViewAdditions.stackAlignment==LEBottomAlign){
            anchor1=LEInsideBottomLeft;
            anchor2=LEOutsideRightBottom;
        }
    }
    for (NSInteger i=0; i<muta.count; i++) {
        UIView *tmp=[muta objectAtIndex:i];
        UIView *view=[UIView new].leAddTo(self).leRelativeTo(last).leWrapper().leAnchor([last isEqual:self]?anchor1:anchor2);
        [tmp.leAddTo(view) leAutoLayout];
        [view leAutoLayout];
        last=view;
    }
}
-(void) lePopFromStack{
    [[self.leViewAdditions popView] leAutoLayout];
}
-(__kindof UIView *(^)(CGFloat)) leEqualSuperViewWidth{
    return ^id(CGFloat value){
        self.leViewAdditions.equalSuperViewWidth=value;
        [self leAutoLayout];
        return self;
    };
}
-(__kindof UIView *(^)(CGFloat)) leEqualSuperViewHeight{
    return ^id(CGFloat value){
        self.leViewAdditions.equalSuperViewHeight=value;
        [self leAutoLayout];
        return self;
    };
}
-(__kindof UIView *(^)(CGFloat)) leEqualRelativeViewWidth{
    return ^id(CGFloat value){
        self.leViewAdditions.equalRelativeViewWidth=value;
        [self leAutoLayout];
        return self;
    };
}
-(__kindof UIView *(^)(CGFloat)) leEqualRelativeViewHeight{
    return ^id(CGFloat value){
        self.leViewAdditions.equalRelativeViewHeight=value;
        [self leAutoLayout];
        return self;
    };
}
-(__kindof UIView *(^)(CGFloat)) leHeightEqualSuperViewWidth{
    return ^id(CGFloat value){
        self.leViewAdditions.heightEqualSuperViewWidth=value;
        [self leAutoLayout];
        return self;
    };
}
-(__kindof UIView *(^)(CGFloat)) leHeightEqualRelativeViewWidth{
    return ^id(CGFloat value){
        self.leViewAdditions.heightEqualRelativeViewWidth=value;
        [self leAutoLayout];
        return self;
    };
}
-(__kindof UIView *(^)(CGFloat)) leWidthEqualHeight{
    return ^id(CGFloat value){
        self.leViewAdditions.widthEqualHeight=value;
        [self leAutoLayout];
        return self;
    };
}
-(__kindof UIView *(^)(CGFloat)) leHeightEqualWidth{
    return ^id(CGFloat value){
        self.leViewAdditions.heightEqualWidth=value;
        [self leAutoLayout];
        return self;
    };
}
-(__kindof UIView *(^)(CGFloat)) leTopEqualHeight{
    return ^id(CGFloat value){
        self.leViewAdditions.topEqualHeight=value;
        [self leAutoLayout];
        return self;
    };
}
-(__kindof UIView *(^)(CGFloat)) leBottomEqualHeight{
    return ^id(CGFloat value){
        self.leViewAdditions.bottomEqualHeight=value;
        [self leAutoLayout];
        return self;
    };
}
-(__kindof UIView *(^)(CGFloat)) leLeftEqualWidth{
    return ^id(CGFloat value){
        self.leViewAdditions.leftEqualWidth=value;
        [self leAutoLayout];
        return self;
    };
}
-(__kindof UIView *(^)(CGFloat)) leRightEqualWidth{
    return ^id(CGFloat value){
        self.leViewAdditions.rightEqualWidth=value;
        [self leAutoLayout];
        return self;
    };
}
//
-(__kindof UIView *(^)(UIFont *)) leFont{
    return ^id(UIFont *value){
        if([self isKindOfClass:[UILabel class]]){
            UILabel *label=(UILabel *)self;
            label.font=value;
        }else if([self isKindOfClass:[UIButton class]]){
            UIButton *view=(UIButton *)self;
            view.titleLabel.font=value;
        }else if([self isKindOfClass:[UITextField class]]){
            UITextField *view=(UITextField *)self;
            [view setFont:value];
        }
        return self;
    };
}
-(__kindof UIView *(^)(CGFloat)) leMaxWidth{
    return ^id(CGFloat value){
        self.leViewAdditions.maxWidth=value;
        return self;
    };
}
-(__kindof UIView *(^)(CGFloat)) leMaxHeight{
    return ^id(CGFloat value){
        self.leViewAdditions.maxHeight=value;
        return self;
    };
}
-(__kindof UIView *(^)(CGFloat)) leMarginForMaxWidth{
    return ^id(CGFloat value){
        self.leViewAdditions.marginForMaxWidth=value;
        return self;
    };
}
-(__kindof UIView *(^)(UIColor *)) leColor{
    return ^id(UIColor *value){
        if([self isKindOfClass:[UILabel class]]){
            UILabel *label=(UILabel *)self;
            label.textColor=value;
        }else if([self isKindOfClass:[UITextField class]]){
            UITextField *view=(UITextField *)self;
            [view setTextColor:value];
        }
        return self;
    };
}
-(__kindof UIView *(^)(NSTextAlignment)) leAlignment{
    return ^id(NSTextAlignment value){
        if([self isKindOfClass:[UILabel class]]){
            UILabel *label=(UILabel *)self;
            label.textAlignment=value;
        }else if([self isKindOfClass:[UITextField class]]){
            UITextField *view=(UITextField *)self;
            [view setTextAlignment:value];
        }
        return self;
    };
}
-(__kindof UIView *) leLeftAlign{
    if([self isKindOfClass:[UILabel class]]){
        UILabel *label=(UILabel *)self;
        label.textAlignment=NSTextAlignmentLeft;
    }else if([self isKindOfClass:[UITextField class]]){
        UITextField *view=(UITextField *)self;
        [view setTextAlignment:NSTextAlignmentLeft];
    }
    return self;
}
-(__kindof UIView *) leRightAlign{
    if([self isKindOfClass:[UILabel class]]){
        UILabel *label=(UILabel *)self;
        label.textAlignment=NSTextAlignmentRight;
    }else if([self isKindOfClass:[UITextField class]]){
        UITextField *view=(UITextField *)self;
        [view setTextAlignment:NSTextAlignmentRight];
    }
    return self;
}
-(__kindof UIView *) leCenterAlign{
    if([self isKindOfClass:[UILabel class]]){
        UILabel *label=(UILabel *)self;
        label.textAlignment=NSTextAlignmentCenter;
    }else if([self isKindOfClass:[UITextField class]]){
        UITextField *view=(UITextField *)self;
        [view setTextAlignment:NSTextAlignmentCenter];
    }
    return self;
}
-(__kindof UIView *(^)(UIImage *img, CGSize)) leImageWithSize{
    return ^id(UIImage *img, CGSize size){
        if([self isKindOfClass:[UIImageView class]]){
            UIImageView *view=(UIImageView *)self;
            view=view.leWidth(size.width).leHeight(size.height);
            [view setImage:img];
        }
        return self;
    };
}
-(__kindof UIView *(^)(UIImage *)) leImage{
    return ^id(UIImage *value){
        if([self isKindOfClass:[UIButton class]]){
            UIButton *view=(UIButton *)self;
            view=view.leBtnImg(value,UIControlStateNormal);
        }else if([self isKindOfClass:[UIImageView class]]){
            UIImageView *view=(UIImageView *)self;
            float w=value.size.width;
            float h=value.size.height;
            w=MIN([self getMaxWidth]?:w, w);
            if(self.leViewAdditions.maxHeight>0){
                h=MIN(self.leViewAdditions.maxHeight, h);
            }
            view=view.leWidth(w).leHeight(h);
            [view setImage:value];
        }
        return self;
    };
}
-(float) getMaxWidth{
    float max=0;
    if(self.leViewAdditions.maxWidth>0){
        max=self.leViewAdditions.maxWidth;
    }else if(self.leViewAdditions.marginForMaxWidth>0){
        max=LESCREEN_WIDTH-self.leViewAdditions.marginForMaxWidth;
    } 
    return max;
}
-(__kindof UIView *(^)(NSString *)) leText{
    return ^id(NSString *value){
        float labelMaxWidth=[self getMaxWidth]?:INT_MAX;
        if([self isKindOfClass:[UILabel class]]){
            UILabel *label=(UILabel *)self;
            label.leViewAdditions.uiText=value;
            [label setText:value];
            CGSize size=CGSizeZero;
            BOOL sizeSet=NO;
            if(value.length>0){
                
                size=[label leSizeWithMaxSize:CGSizeMake(labelMaxWidth, label.leViewAdditions.maxHeight==0?INT_MAX:label.leViewAdditions.maxHeight)];
                if(self.leViewAdditions.lineSpace>0){
                    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:label.text];
                    NSMutableParagraphStyle *paragraphStyle=nil;
                    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
                    [dic setObject:label.font forKey:NSFontAttributeName];
                    if(self.leViewAdditions.lineSpace>0){
                        paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                        [paragraphStyle setLineSpacing:self.leViewAdditions.lineSpace];
                        [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
                        [paragraphStyle setAlignment:label.textAlignment];
                        [dic setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
                    }
                    [attributedString addAttributes:dic range:NSMakeRange(0, label.text.length)];
                    [label setAttributedText:attributedString];
                    //
                    CGRect rect = [attributedString leRectWithMaxSize:CGSizeMake(labelMaxWidth, INT_MAX)];
                    //中文单行 size计算不准确的处理
                    if(rect.size.height<=label.font.lineHeight+self.leViewAdditions.lineSpace){
                        NSMutableAttributedString *attr=[[NSMutableAttributedString alloc] initWithAttributedString:attributedString];
                        [attr addAttribute:NSBaselineOffsetAttributeName value:[NSNumber numberWithInt: -self.leViewAdditions.lineSpace/4+1] range:NSMakeRange(0, label.text.length)];
                        [label setAttributedText:attr];
                        label=label.leWidth(rect.size.width).leHeight(label.font.lineHeight);
                        sizeSet=YES;
                    }else if(rect.size.height==label.font.lineHeight+self.leViewAdditions.lineSpace){
                        [label setAttributedText:[[NSAttributedString alloc] initWithString:label.text]];
                        label=label.leWidth(rect.size.width).leHeight(label.font.lineHeight);
                        sizeSet=YES;
                    }else{
                        label.leWidth(rect.size.width);
                    }
                }
            }
            if(!sizeSet){
                label=label.leWidth(size.width).leHeight(size.height);
            }
            if(label.numberOfLines!=0){
                float height=(label.numberOfLines>1?label.numberOfLines-1:0)*self.leViewAdditions.lineSpace+label.numberOfLines*label.font.lineHeight;
                label.leHeight(height);
                [label setLineBreakMode:NSLineBreakByTruncatingTail];
            }
        }else if([self isKindOfClass:[UIButton class]]){
            UIButton *view=(UIButton *)self;
            view.leViewAdditions.uiText=value;
            if(!value||value.length==0||view.imageView.hidden){
                view.imageEdgeInsets=UIEdgeInsetsZero;
                view.titleEdgeInsets=UIEdgeInsetsZero;
            }
            [view setTitle:value forState:UIControlStateNormal];
            float w=self.leViewAdditions.fixedButtonSize.width;
            float h=self.leViewAdditions.fixedButtonSize.height;
            UILabel *label=view.titleLabel;
            CGSize textSize=CGSizeZero;
            float insetW=self.leViewAdditions.buttonContentInsects.width?:8;
            float insetH=self.leViewAdditions.buttonContentInsects.height?:8;
            if(!self.leViewAdditions.isButtonVerticalLayout){
                if(!view.imageView.hidden&&value&&value.length>0){
                    view.imageEdgeInsets=UIEdgeInsetsMake(0, -insetW/2, 0, 0);
                    view.titleEdgeInsets=UIEdgeInsetsMake(0, insetW/2, 0, 0);
                }
            }
            if(w>0&&h==0){//定宽
                textSize=[label leSizeWithMaxSize:CGSizeMake(w-insetW*2, INT_MAX)];
                if(self.leViewAdditions.isButtonVerticalLayout){//垂直排版
                    h=insetH+(view.imageView.hidden?0:view.imageView.image.size.height+insetH)+textSize.height+insetH;
                    h=MIN(self.leViewAdditions.maxHeight>0?:h, h);
                }else{
                    h=MAX(textSize.height, view.imageView.hidden?0:view.imageView.image.size.height)+insetH*2;
                }
            }else if(w==0&&h>0){//定高
                textSize=[label leSizeWithMaxSize:CGSizeMake(INT_MAX, INT_MAX)];
                w=insetW+(view.imageView.hidden?0:view.imageView.image.size.width+insetW)+textSize.width+insetW;
                w=MIN([self getMaxWidth]?:w, w);
            }else if(w==0&&h==0){//未定宽高
                textSize=[label leSizeWithMaxSize:CGSizeMake([self getMaxWidth]?:INT_MAX, self.leViewAdditions.maxHeight?:INT_MAX)];
                if(self.leViewAdditions.isButtonVerticalLayout){//垂直排版
                    w=MAX(textSize.width, view.imageView.hidden?0:view.imageView.image.size.width)+insetW*2;
                    h=insetH+(view.imageView.hidden?0:view.imageView.image.size.height+insetH)+textSize.height+insetH;
                }else{
                    w=insetW+(view.imageView.hidden?0:view.imageView.image.size.width+insetW)+textSize.width+insetW;
                    h=MAX(textSize.height, view.imageView.hidden?0:view.imageView.image.size.height)+insetH*2;
                }
                w=MIN([self getMaxWidth]?:w, w);
                h=MIN(self.leViewAdditions.maxHeight>0?:h, h);
            }
            view=view.leWidth(w).leHeight(h);
        }else if([self isKindOfClass:[UITextField class]]){
            UITextField *view=(UITextField *)self;
            [view setText:value];
        }
        [self leAutoLayout];
        return self;
    };
}
#pragma mark Label
-(__kindof UIView *(^)(NSInteger)) leLine{
    return ^id(NSInteger value){
        if([self isKindOfClass:[UILabel class]]){
            UILabel *label=(UILabel *)self;
            label.numberOfLines=value;
        }else if([self isKindOfClass:[UIButton class]]){
            UIButton *button=(UIButton *)self;
            button.titleLabel.numberOfLines=value;
        }
        return self;
    };
}
-(__kindof UIView *(^)(CGFloat)) leLineSpace{
    return ^id(CGFloat value){
        self.leViewAdditions.lineSpace=value;
        return self;
    };
}
#pragma mark Button

-(__kindof UIView *(^)(BOOL)) leIgnoreTouchEventLock{
    return ^id(BOOL value){
        self.leViewAdditions.isIgnoreTouchEventLock=value;
        return self;
    };
}
-(__kindof UIView *(^)(BOOL)) leBtnVerticalLayout{
    return ^id(BOOL value){
        self.leViewAdditions.isButtonVerticalLayout=value;
        if([self isKindOfClass:[UIButton class]]){
            UIButton *button=(UIButton *)self;
            button.titleLabel.textAlignment=NSTextAlignmentCenter;
            button=button.leBtnFixedWidth(0);
        }
        return self;
    };
}
-(__kindof UIView *(^)(CGFloat)) leBtnFixedWidth{
    return ^id(CGFloat value){
        self.leViewAdditions.fixedButtonSize=CGSizeMake(value, self.leViewAdditions.fixedButtonSize.height);
        return self;
    };
}
-(__kindof UIView *(^)(CGFloat)) leBtnFixedHeight{
    return ^id(CGFloat value){
        self.leViewAdditions.fixedButtonSize=CGSizeMake(self.leViewAdditions.fixedButtonSize.width, value);
        return self;
    };
}
-(__kindof UIView *(^)(CGSize)) leBtnFixedSize{
    return ^id(CGSize value){
        self.leViewAdditions.fixedButtonSize=value;
        return self;
    };
}
-(__kindof UIView *(^)(UIImage *, UIControlState state)) leBtnImg{
    return ^id(UIImage *img, UIControlState state){
        if([self isKindOfClass:[UIButton class]]){
            UIButton *view=(UIButton *)self;
            [view setImage:img forState:state];
            view=view.leText(view.leViewAdditions.uiText);
        }
        return self;
    };
}
-(__kindof UIView *(^)(UIImage *, UIControlState state)) leBtnBGImg{
    return ^id(UIImage *img, UIControlState state){
        if([self isKindOfClass:[UIButton class]]){
            UIButton *view=(UIButton *)self;
            [view setBackgroundImage:img forState:state];
        }
        return self;
    };
}
-(__kindof UIView *(^)(UIColor *, UIControlState state)) leBtnColor{
    return ^id(UIColor *color, UIControlState state){
        if([self isKindOfClass:[UIButton class]]){
            UIButton *view=(UIButton *)self;
            [view setTitleColor:color forState:state];
        }
        return self;
    };
}
-(__kindof UIView *(^)(UIImage *)) leBtnImg_N{
    return ^id(UIImage *value){
        if([self isKindOfClass:[UIButton class]]){
            UIButton *view=(UIButton *)self;
            [view setImage:value forState:UIControlStateNormal];
            view=view.leText(view.leViewAdditions.uiText);
        }
        return self;
    };
}
-(__kindof UIView *(^)(UIImage *)) leBtnImg_H{
    return ^id(UIImage *value){
        if([self isKindOfClass:[UIButton class]]){
            UIButton *view=(UIButton *)self;
            [view setImage:value forState:UIControlStateHighlighted];
            view=view.leText(view.leViewAdditions.uiText);
        }
        return self;
    };
}
-(__kindof UIView *(^)(UIImage *)) leBtnBGImgN{
    return ^id(UIImage *value){
        if([self isKindOfClass:[UIButton class]]){
            UIButton *view=(UIButton *)self;
            [view setBackgroundImage:value forState:UIControlStateNormal];
        }
        return self;
    };
}
-(__kindof UIView *(^)(UIImage *)) leBtnBGImgH{
    return ^id(UIImage *value){
        if([self isKindOfClass:[UIButton class]]){
            UIButton *view=(UIButton *)self;
            [view setBackgroundImage:value forState:UIControlStateHighlighted];
        }
        return self;
    };
}
-(__kindof UIView *(^)(UIColor *)) leBtnColorN{
    return ^id(UIColor *value){
        if([self isKindOfClass:[UIButton class]]){
            UIButton *view=(UIButton *)self;
            [view setTitleColor:value forState:UIControlStateNormal];
        }
        return self;
    };
}
-(__kindof UIView *(^)(UIColor *)) leBtnColorH{
    return ^id(UIColor *value){
        if([self isKindOfClass:[UIButton class]]){
            UIButton *view=(UIButton *)self;
            [view setTitleColor:value forState:UIControlStateHighlighted];
        }
        return self;
    };
}
-(__kindof UIView *(^)(CGFloat)) leBtnVInsect{
    return ^id(CGFloat value){
        self.leViewAdditions.buttonContentInsects=CGSizeMake(self.leViewAdditions.buttonContentInsects.width, value);
        return self;
    };
}
-(__kindof UIView *(^)(CGFloat)) leBtnHInsect{
    return ^id(CGFloat value){
        self.leViewAdditions.buttonContentInsects=CGSizeMake(value, self.leViewAdditions.buttonContentInsects.height);
        return self;
    };
}
#pragma mark Textfield
-(__kindof UIView *(^)(NSString *)) leTextPlaceHolder{
    return ^id(NSString *value){
        if([self isKindOfClass:[UITextField class]]){
            UITextField *view=(UITextField *)self;
            [view setPlaceholder:value];
        }
        return self;
    };
}
-(__kindof UIView *(^)(UIReturnKeyType)) leReturnType{
    return ^id(UIReturnKeyType value){
        if([self isKindOfClass:[UITextField class]]){
            UITextField *view=(UITextField *)self;
            [view setReturnKeyType:value];
        }
        return self;
    };
}
-(__kindof UIView *(^)(id<UITextFieldDelegate>)) leTextDelegate{
    return ^id(id<UITextFieldDelegate> value){
        if([self isKindOfClass:[UITextField class]]){
            UITextField *view=(UITextField *)self;
            [view setDelegate:value];
        }
        return self;
    };
}
#pragma mark Auto
-(void) leAutoLayout{
    CGRect frame=[self.leViewAdditions leGetFrame];
    if(!CGRectEqualToRect(frame, self.frame)){
        [self setFrame:frame];
        LEViewType type=self.leViewAdditions.viewType;
        if(type==LEWrapperView||type==LEVerticalStack||type==LEHorizontalStack){
            for (UIView *v in self.subviews) {
                if(v.leViewAdditions.superView){
                    [v setFrame:[v.leViewAdditions leGetFrame]];
                }
            }
        }else{
            for (UIView *v in self.subviews) {
                if(v.leViewAdditions.superView){
                    [v leAutoLayout];
                }
            }
        }
        if(self.leViewAdditions.related.count>0){
            for (NSInteger i=self.leViewAdditions.related.count-1; i>=0; i--) {
//                UIView *view=[[self.leViewAdditions.related objectAtIndex:i] ownerView];
                UIView *view=[[[self.leViewAdditions.related objectAtIndex:i] leGet] ownerView];
                if(view){
                    [view leAutoLayout];
                }else{
                    [self.leViewAdditions.related removeObjectAtIndex:i];
                }
            }
        }
    } 
    LEViewType type=self.leViewAdditions.superView.leViewAdditions.viewType;
    if(type>0){
        UIView *stack=self.leViewAdditions.superView;
        UIView *vt=nil;
        UIView *vl=nil;
        UIView *vb=nil;
        UIView *vr=nil;
        for (NSInteger i=0; i<stack.subviews.count; i++) {
            UIView *view=[stack.subviews objectAtIndex:i];
            if(view.leViewAdditions.superView){
                if(view&&!view.hidden){
                    if(!vt){
                        vt=view;
                        vl=view;
                        vb=view;
                        vr=view;
                    }else {
                        if((view.frame.origin.y-view.leViewAdditions.topMargin)<(vt.frame.origin.y-vt.leViewAdditions.topMargin)){
                            vt=view;
                        }
                        if((view.frame.origin.x-view.leViewAdditions.leftMargin)<(vl.frame.origin.x-vl.leViewAdditions.leftMargin)){
                            vl=view;
                        }
                        if((view.frame.origin.y+view.frame.size.height+view.leViewAdditions.bottomMargin)>(vb.frame.origin.y+vb.frame.size.height+vb.leViewAdditions.bottomMargin)){
                            vb=view;
                        }
                        if((view.frame.origin.x+view.frame.size.width+view.leViewAdditions.rightMargin)>(vr.frame.origin.x+vr.frame.size.width+vr.leViewAdditions.rightMargin)){
                            vr=view;
                        }
                    }
                }
            }
        }
        float sumW=0;
        float sumH=0;
        if(vt){
            sumW=vr.frame.origin.x+vr.frame.size.width+vr.leViewAdditions.rightMargin-vl.frame.origin.x+vl.leViewAdditions.leftMargin;
            sumH=vb.frame.origin.y+vb.frame.size.height+vb.leViewAdditions.bottomMargin-vt.frame.origin.y+vt.leViewAdditions.topMargin;
        }
        if(type==LEWrapperView||type==LEVerticalStack||type==LEHorizontalStack){
            stack.leViewAdditions.width=sumW;
            stack.leViewAdditions.height=sumH;
            [stack leAutoLayout];
            
        }else if((type==LEAutoResizeContentView)&&[stack isKindOfClass:[UIScrollView class]]){
            [(UIScrollView *)stack setContentSize:CGSizeMake(MAX(stack.bounds.size.width, sumW), MAX(stack.bounds.size.height, sumH))];
        }else if(type==LEAutoCalcHeight){
            stack.leViewAdditions.width=stack.bounds.size.width;
            stack.leHeight(sumH);
        }
    }
}
-(CGFloat) leGetCellHeightWithBottomView:(UIView *) view{
    return view.frame.origin.y+view.frame.size.height+view.leViewAdditions.bottomMargin;
}
-(void) setLeViewAdditions:(LEViewAdditions *)leViewAdditions{
    objc_setAssociatedObject(self, @selector(leViewAdditions), leViewAdditions, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(LEViewAdditions *) leViewAdditions{ 
    LEViewAdditions *additions= objc_getAssociatedObject(self, _cmd);
    if(!additions){
        additions=[[LEViewAdditions alloc] initWithOwner:self];
        self.leViewAdditions=additions;
    }
    return additions; 
}
#pragma mark Split line
-(__kindof UIView *(^)(UIColor *color, CGFloat offset, CGFloat width)) leAddTopSplitline{
    return ^id(UIColor *color, CGFloat offset, CGFloat width){
        [UIView new].leAddTo(self).leAnchor(LEInsideTopCenter).leBgColor(color).leTop(offset).leWidth(width).leHeight(LESplitlineH);
        return self;
    };
}
-(__kindof UIView *(^)(UIColor *color, CGFloat offset, CGFloat width)) leAddBottomSplitline{
    return ^id(UIColor *color, CGFloat offset, CGFloat width){
        [UIView new].leAddTo(self).leAnchor(LEInsideBottomCenter).leBgColor(color).leBottom(offset).leWidth(width).leHeight(LESplitlineH);
        return self;
    };
}
-(__kindof UIView *(^)(UIColor *color, CGFloat offset, CGFloat height)) leAddLeftSplitline{
    return ^id(UIColor *color, CGFloat offset, CGFloat height){
        [UIView new].leAddTo(self).leAnchor(LEInsideLeftCenter).leBgColor(color).leLeft(offset).leHeight(height).leWidth(LESplitlineH);
        return self;
    };
}
-(__kindof UIView *(^)(UIColor *color, CGFloat offset, CGFloat height)) leAddRightSplitline{
    return ^id(UIColor *color, CGFloat offset, CGFloat height){
        [UIView new].leAddTo(self).leAnchor(LEInsideRightCenter).leBgColor(color).leRight(offset).leHeight(height).leWidth(LESplitlineH);
        return self;
    };
}
-(void) leEndEdit{
    [self endEditing:YES];
}
@end
//
@interface LETouchEventLock : NSObject
LESingleton_interface(LETouchEventLock)
-(BOOL) isTouchEventLocked;
@end
@implementation LETouchEventLock{
    BOOL touchEventLock;
}
LESingleton_implementation(LETouchEventLock)
-(BOOL) isTouchEventLocked{
    BOOL lock=touchEventLock;
    if(!touchEventLock){
        touchEventLock=YES;
        [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(unLockTouchEvent) userInfo:nil repeats:NO];
    }else NSLog(@"Touch event was ignored for too many in 0.6s");
    return lock;
}
-(void) unLockTouchEvent{
    touchEventLock=NO;
}
@end
@implementation UIControl (LEDelayTouchEvent)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SEL originalSelector = @selector(sendAction:to:forEvent:);
        SEL swizzledSelector = @selector(leSendAction:to:forEvent:);
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}
- (void)leSendAction:(SEL)action to:(nullable id)target forEvent:(nullable UIEvent *)event{
    if (!self.leViewAdditions.isIgnoreTouchEventLock&&event.type == UIEventTypeTouches && [[event.allTouches anyObject] phase] == UITouchPhaseBegan&&![LETouchEventLock sharedInstance].isTouchEventLocked){
        [self leSendAction:action to:target forEvent:event];
    }else{
        [self leSendAction:action to:target forEvent:event];
    }
}
@end
@implementation UIButton (LEVerticalButton)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SEL originalSelector = @selector(layoutSubviews);
        SEL swizzledSelector = @selector(leLayoutSubviews);
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}
-(void)leLayoutSubviews {
    [self leLayoutSubviews];
    if(self.leViewAdditions.isButtonVerticalLayout){
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        CGFloat sumHeight = self.imageView.frame.size.height + self.titleLabel.frame.size.height + 8;
        CGRect imageFrame = self.imageView.frame;
        imageFrame.origin = CGPointMake(truncf((self.bounds.size.width - self.imageView.frame.size.width) / 2), truncf((self.bounds.size.height - sumHeight) / 2));
        self.imageView.frame = imageFrame;
        CGRect labelFrame = CGRectMake(0, CGRectGetMaxY(imageFrame) + 8, self.bounds.size.width, self.titleLabel.frame.size.height);
        self.titleLabel.frame = labelFrame;
    }
}
@end
@implementation UILabel (LEAdditions)
-(CGSize) leSizeWithMaxSize:(CGSize) size{
    if(self.text.length==0){
        return CGSizeZero;
    }
    NSMutableDictionary *dic=[NSMutableDictionary new];
    [dic setObject:self.font forKey:NSFontAttributeName];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    [paragraphStyle setAlignment:self.textAlignment];
    if(self.leViewAdditions.lineSpace>0){
        [paragraphStyle setLineSpacing:self.leViewAdditions.lineSpace];
    }
    [dic setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    CGRect rect = [self.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    rect.size.height=rect.size.height+1;
    return rect.size;
}
@end

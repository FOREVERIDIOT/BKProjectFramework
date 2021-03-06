//
//  BKImagePreviewViewController.m
//  BKImagePicker
//
//  Created by BIKE on 2018/2/6.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "BKImagePreviewViewController.h"
#import "BKImagePreviewCollectionViewFlowLayout.h"
#import "BKImagePreviewCollectionViewCell.h"
#import "BKImageAlbumItemSelectButton.h"
#import "BKImagePreviewInteractiveTransition.h"
#import "BKImagePreviewTransitionAnimater.h"
#import "BKEditImageViewController.h"
#import "BKImageOriginalButton.h"
#import "BKImagePickerMacro.h"
#import "BKImagePickerConstant.h"
#import "UIView+BKImagePicker.h"
#import "BKImagePicker.h"

@interface BKImagePreviewViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate>

@property (nonatomic,assign) BOOL isFirstEnterIntoVC;//是否第一次进入vc

@property (nonatomic,strong) BKImageAlbumItemSelectButton * rightNavBtn;

@property (nonatomic,strong) UIButton * editBtn;
@property (nonatomic,strong) BKImageOriginalButton * originalBtn;
@property (nonatomic,strong) UIButton * sendBtn;

@property (nonatomic,assign) NSInteger currentImageIndex;//当前image的index
@property (nonatomic,assign) BOOL isLoadOver;//是否加载完毕
@property (nonatomic,assign) BOOL currentOriginalImageLoadedFlag;//当前image的原图是否加载完毕

@property (nonatomic,strong) UICollectionView * exampleImageCollectionView;

@property (nonatomic,strong) UINavigationController * nav;//导航
@property (nonatomic,strong) BKImagePreviewInteractiveTransition * interactiveTransition;//交互方法

@end

@implementation BKImagePreviewViewController

#pragma mark - 显示方法

-(void)showInNav:(UINavigationController*)nav
{
    _nav = nav;
    _nav.delegate = self;
    [_nav pushViewController:self animated:YES];
}

#pragma mark - BKImagePreviewInteractiveTransition

-(BKImagePreviewInteractiveTransition*)interactiveTransition
{
    if (!_interactiveTransition) {
        _interactiveTransition = [[BKImagePreviewInteractiveTransition alloc] init];
        [_interactiveTransition addPanGestureForViewController:self];
    }
    return _interactiveTransition;
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPush) {
        
        UIImageView * imageView = [self getTapImageView];
        
        BKImagePreviewTransitionAnimater * transitionAnimater = [[BKImagePreviewTransitionAnimater alloc] initWithTransitionType:BKShowExampleTransitionPush];
        transitionAnimater.startImageView = imageView;
        transitionAnimater.endRect = [self calculateTargetFrameWithImageView:imageView];
        BK_WEAK_SELF(self);
        [transitionAnimater setEndTransitionAnimateAction:^{
            BK_STRONG_SELF(self);
            strongSelf.exampleImageCollectionView.hidden = NO;
        }];
        
        return transitionAnimater;
    }else{
        
        CGRect endRect = [self.delegate getFrameOfCurrentImageInListVCWithImageModel:self.imageListArray[_currentImageIndex]];
        
        BKImagePreviewTransitionAnimater * transitionAnimater = [[BKImagePreviewTransitionAnimater alloc] initWithTransitionType:BKShowExampleTransitionPop];
        transitionAnimater.startImageView = self.interactiveTransition.startImageView;
        transitionAnimater.endRect = endRect;
        transitionAnimater.alphaPercentage = self.interactiveTransition.interation?[self.interactiveTransition getCurrentViewAlphaPercentage]:1;
        BK_WEAK_SELF(self);
        [transitionAnimater setEndTransitionAnimateAction:^{
            BK_STRONG_SELF(self);
            strongSelf.exampleImageCollectionView.hidden = NO;
            strongSelf.nav.delegate = nil;
        }];
        
        return transitionAnimater;
    }
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    return self.interactiveTransition.interation?self.interactiveTransition:nil;
}

/**
 获取初始点击图片
 
 @return 图片
 */
-(UIImageView*)getTapImageView
{
    CGRect parentRect = [_tapImageView.superview convertRect:_tapImageView.frame toView:self.view];
    
    UIImageView * newImageView = [[UIImageView alloc]initWithFrame:parentRect];
    newImageView.contentMode = UIViewContentModeScaleAspectFill;
    newImageView.clipsToBounds = YES;
    if (_tapImageView.image) {
        newImageView.image = _tapImageView.image;
    }
    
    return newImageView;
}

/**
 获取初始图片动画后frame
 
 @param imageView 初始点击图片
 @return frame
 */
-(CGRect)calculateTargetFrameWithImageView:(UIImageView*)imageView
{
    CGRect targetFrame = CGRectZero;
    
    UIImage * image = imageView.image;
    
    targetFrame.size.width = self.view.frame.size.width;
    if (image) {
        CGFloat scale = image.size.width / targetFrame.size.width;
        targetFrame.size.height = image.size.height/scale;
        if (targetFrame.size.height < self.view.frame.size.height) {
            targetFrame.origin.y = (self.view.frame.size.height - targetFrame.size.height)/2;
        }
    }else{
        targetFrame.size.height = self.view.frame.size.width;
        targetFrame.origin.y = (self.view.frame.size.height - targetFrame.size.height)/2;
    }
    
    return targetFrame;
}

#pragma mark - viewDidload

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isFirstEnterIntoVC = YES;
    
    [self initTopNav];
    [self initBottomNav];
    [self exampleImageCollectionView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.isFirstEnterIntoVC) {
        [_exampleImageCollectionView reloadItemsAtIndexPaths:[_exampleImageCollectionView indexPathsForVisibleItems]];
        
        [self calculataImageSizeWithSelectIndex:INT_MAX];
        [self refreshBottomNavBtnStateWithSelectIndex:INT_MAX];
    }
    self.isFirstEnterIntoVC = NO;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.nav.delegate = self;
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.exampleImageCollectionView.frame = CGRectMake(-BKExampleImagesSpacing, 0, self.view.bk_width + 2*BKExampleImagesSpacing, self.view.bk_height);
}

-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"currentImageIndex"];
}

#pragma mark - initTopNav

-(void)initTopNav
{
    [self addObserver:self forKeyPath:@"currentImageIndex" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    if ([self.imageListArray count] == 1) {
        self.title = @"预览";
    }else{
        if ([_imageListArray count] > 0 && _tapImageModel) {
            self.currentImageIndex = [self.imageListArray indexOfObject:self.tapImageModel];
        }
        self.title = [NSString stringWithFormat:@"%ld/%ld",_currentImageIndex+1,[self.imageListArray count]];
    }
    
    if ([BKImagePicker sharedManager].imageManageModel.max_select > 1) {
//        [self.rightBtn addSubview:self.rightNavBtn];
        BKNavButton * rightNavBtn = [[BKNavButton alloc] init];
        [rightNavBtn addSubview:self.rightNavBtn];
        self.rightNavBtn.frame = CGRectMake((rightNavBtn.bk_width - 30)/2, (rightNavBtn.bk_height - 30)/2, 30, 30);
        self.rightNavBtns = @[rightNavBtn];
    }
}

-(BKImageAlbumItemSelectButton*)rightNavBtn
{
    if (!_rightNavBtn) {
        _rightNavBtn = [[BKImageAlbumItemSelectButton alloc] init];
        __weak typeof(self) weakSelf = self;
        [_rightNavBtn setSelectButtonClick:^(BKImageAlbumItemSelectButton * button) {
            [weakSelf rightBtnClick:button];
        }];
        
        if ([self.imageListArray count] == 1) {
            if ([[BKImagePicker sharedManager].imageManageModel.selectImageArray count] == 1) {
                _rightNavBtn.title = @"1";
            }else{
                _rightNavBtn.title = @"0";
            }
        }
    }
    return _rightNavBtn;
}

-(void)rightBtnClick:(BKImageAlbumItemSelectButton*)button
{
    BKImageModel * model = self.imageListArray[_currentImageIndex];
    BOOL isHave = [[BKImagePicker sharedManager].imageManageModel.selectImageArray containsObject:model];
    if (!isHave && [[BKImagePicker sharedManager].imageManageModel.selectImageArray count] >= [BKImagePicker sharedManager].imageManageModel.max_select) {
        [self.view bk_showRemind:[NSString stringWithFormat:@"最多只能选择%ld张照片",[BKImagePicker sharedManager].imageManageModel.max_select]];
        return;
    }
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForItem:_currentImageIndex inSection:0];
    BKImagePreviewCollectionViewCell * cell = (BKImagePreviewCollectionViewCell*)[_exampleImageCollectionView cellForItemAtIndexPath:indexPath];
    
    if (isHave) {
        
        [[BKImagePicker sharedManager].imageManageModel.selectImageArray removeObject:model];
        [button cancelSelect];
        
        [cell bk_hideLoadLayer];
    }else{
        [[BKImagePicker sharedManager].imageManageModel.selectImageArray addObject:model];
        [button selectClickNum:[[BKImagePicker sharedManager].imageManageModel.selectImageArray count]];
        
        if (model.loadingProgress != 1) {
            
            [cell bk_showLoadLayer];
            
            [[BKImagePicker sharedManager] getOriginalImageDataWithAsset:model.asset progressHandler:^(double progress, NSError *error, PHImageRequestID imageRequestID) {
                
                if (error) {
                    [cell bk_hideLoadLayer];
                    model.loadingProgress = 0;
                    return;
                }
                
                [cell bk_showLoadLayerWithDownLoadProgress:progress];
                model.loadingProgress = progress;
                
            } complete:^(NSData *originalImageData, NSURL *url, PHImageRequestID imageRequestID) {
                
                [cell bk_hideLoadLayer];
                
                if (originalImageData) {
                    model.thumbImageData = [[BKImagePicker sharedManager] compressImageData:originalImageData];
                    model.originalImageData = originalImageData;
                    model.loadingProgress = 1;
                    model.originalImageSize = (double)originalImageData.length/1024/1024;
                    model.url = url;
                    
                    [self calculataImageSizeWithSelectIndex:INT_MAX];
                    [self refreshBottomNavBtnStateWithSelectIndex:INT_MAX];
                }else{
                    model.loadingProgress = 0;
                    [self.view bk_showRemind:BKOriginalImageDownloadFailedRemind];
                    //删除选中的自己
                    [self rightBtnClick:button];
                }
            }];
        }
    }
    
    [self calculataImageSizeWithSelectIndex:INT_MAX];
    [self refreshBottomNavBtnStateWithSelectIndex:INT_MAX];
}

#pragma mark - initBottomNav

-(void)initBottomNav
{
    self.bottomNavViewHeight = bk_get_system_tabbar_height();
    
    [self.bottomNavView addSubview:self.editBtn];
    if ([BKImagePicker sharedManager].imageManageModel.isHaveOriginal) {
        [self.bottomNavView addSubview:self.originalBtn];
    }
    [self.bottomNavView addSubview:self.sendBtn];
    
    [self refreshBottomNavBtnStateWithSelectIndex:INT_MAX];
}


/**
 更新底部按钮状态

 @param selectIndex 即将选中显示cell的index
 */
-(void)refreshBottomNavBtnStateWithSelectIndex:(NSInteger)selectIndex
{
    __block BOOL canEidtFlag = YES;
    __block BOOL isContainsLoading = NO;
    if ([[BKImagePicker sharedManager].imageManageModel.selectImageArray count] > 0) {
        [[BKImagePicker sharedManager].imageManageModel.selectImageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BKImageModel * currentImageModel = obj;
            if (currentImageModel.photoType != BKSelectPhotoTypeImage) {
                canEidtFlag = NO;
            }
            if (currentImageModel.loadingProgress != 1) {
                isContainsLoading = YES;
            }
            if (canEidtFlag == NO && isContainsLoading == YES) {
                *stop = YES;
            }
        }];
    }else{
        BKImageModel * currentImageModel = self.imageListArray[selectIndex==INT_MAX?_currentImageIndex:selectIndex];
        if (currentImageModel.photoType != BKSelectPhotoTypeImage) {
            canEidtFlag = NO;
        }
        if (currentImageModel.loadingProgress != 1) {
            isContainsLoading = YES;
        }
    }
    
    if (canEidtFlag) {
        [_editBtn setTitleColor:BKImagePickerSendHighlightedBackgroundColor forState:UIControlStateNormal];
    }else{
        [_editBtn setTitleColor:BKImagePickerSendTitleNormalColor forState:UIControlStateNormal];
    }
    
    if (isContainsLoading) {
        [_sendBtn setTitleColor:BKImagePickerSendTitleNormalColor forState:UIControlStateNormal];
        [_sendBtn setBackgroundColor:BKImagePickerSendNormalBackgroundColor];
    }else{
        [_sendBtn setTitleColor:BKImagePickerSendTitleHighlightedColor forState:UIControlStateNormal];
        [_sendBtn setBackgroundColor:BKImagePickerSendHighlightedBackgroundColor];
    }
    if ([[BKImagePicker sharedManager].imageManageModel.selectImageArray count] == 0) {
        [_sendBtn setTitle:@"确认" forState:UIControlStateNormal];
    }else {
        [_sendBtn setTitle:[NSString stringWithFormat:@"确认(%ld)",[[BKImagePicker sharedManager].imageManageModel.selectImageArray count]] forState:UIControlStateNormal];
    }
}

-(UIButton*)editBtn
{
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _editBtn.frame = CGRectMake(0, 0, self.view.bk_width / 6, bk_get_system_tabbar_ui_height());
        [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [_editBtn setTitleColor:BKImagePickerSendTitleNormalColor forState:UIControlStateNormal];
        _editBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBtn;
}

-(BKImageOriginalButton*)originalBtn
{
    if (!_originalBtn) {
        _originalBtn = [[BKImageOriginalButton alloc] initWithFrame:CGRectMake(BK_SCREENW/6, 0, BK_SCREENW/7*3, bk_get_system_tabbar_ui_height())];
        [self calculataImageSizeWithSelectIndex:INT_MAX];
        
        BK_WEAK_SELF(self);
        [_originalBtn setTapSelctAction:^{
            BK_STRONG_SELF(self);
            [strongSelf originalBtnClick];
        }];
    }
    return _originalBtn;
}

-(UIButton*)sendBtn
{
    if (!_sendBtn) {
        
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendBtn.frame = CGRectMake(self.view.bk_width/5*4, 6, self.view.bk_width/5-6, 37);
        [_sendBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:BKImagePickerSendTitleHighlightedColor forState:UIControlStateNormal];
        [_sendBtn setBackgroundColor:BKImagePickerSendHighlightedBackgroundColor];
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _sendBtn.layer.cornerRadius = 4;
        _sendBtn.clipsToBounds = YES;
        [_sendBtn addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _sendBtn;
}

-(void)editBtnClick:(UIButton*)button
{
    if ([[BKImagePicker sharedManager].imageManageModel.selectImageArray count] > 0) {
        
        __block NSMutableArray * selectImageArr = [NSMutableArray array];
        __block NSInteger prepareIndex = 0;
        
        [[BKImagePicker sharedManager].imageManageModel.selectImageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BKImageModel * model = obj;
            if (model.photoType != BKSelectPhotoTypeImage) {
                return;
            }
            
            [selectImageArr addObject:@""];
            
            [self prepareEditWithImageModel:model complete:^(UIImage *image) {
                if (idx < [selectImageArr count]) {
                    [selectImageArr replaceObjectAtIndex:idx withObject:image];
                }
                prepareIndex++;
                
                if (prepareIndex == [[BKImagePicker sharedManager].imageManageModel.selectImageArray count]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self pushEditImageVCWithEditImageArr:[selectImageArr copy]];
                    });
                }
            }];
        }];
        
    }else{
        BKImageModel * model = _imageListArray[_currentImageIndex];
        if (model.photoType != BKSelectPhotoTypeImage) {
            return;
        }
        
        [self prepareEditWithImageModel:model complete:^(UIImage *image) {
            [self pushEditImageVCWithEditImageArr:@[image]];
        }];
    }
}

-(void)prepareEditWithImageModel:(BKImageModel*)imageModel complete:(void (^)(UIImage * image))complete
{
    if (imageModel.loadingProgress == 1) {
        if (complete) {
            complete([UIImage imageWithData:imageModel.originalImageData]);
        }
    }else{
        [[BKImagePicker sharedManager] getOriginalImageDataWithAsset:imageModel.asset progressHandler:^(double progress, NSError *error, PHImageRequestID imageRequestID) {
            
            imageModel.loadingProgress = progress;
            
        } complete:^(NSData *originalImageData, NSURL *url, PHImageRequestID imageRequestID) {
            
            UIImage * resultImage = [UIImage imageWithData:imageModel.originalImageData];
            if (resultImage) {
                imageModel.originalImageData = originalImageData;
                imageModel.loadingProgress = 1;
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    imageModel.thumbImageData = [[BKImagePicker sharedManager] compressImageData:originalImageData];
                });
                imageModel.url = url;
                imageModel.originalImageSize = (double)originalImageData.length/1024/1024;
                
                if (complete) {
                    complete(resultImage);
                }
            }else{
                imageModel.loadingProgress = 0;
            }
        }];
    }
}

-(void)pushEditImageVCWithEditImageArr:(NSArray<UIImage*>*)imageArr
{
    BKEditImageViewController * vc = [[BKEditImageViewController alloc]init];
    vc.editImageArr = imageArr;
    vc.fromModule = BKEditImageFromModulePhotoAlbum;
    self.nav.delegate = nil;
    [self.nav pushViewController:vc animated:YES];
}

-(void)originalBtnClick
{
    [BKImagePicker sharedManager].imageManageModel.isOriginal = ![BKImagePicker sharedManager].imageManageModel.isOriginal;
    
    [self calculataImageSizeWithSelectIndex:INT_MAX];
}

/**
 计算图的大小

 @param selectIndex 即将选中显示cell的index
 */
-(void)calculataImageSizeWithSelectIndex:(NSInteger)selectIndex
{
    if ([BKImagePicker sharedManager].imageManageModel.isOriginal) {
        
        [_originalBtn setTitleColor:BKImagePickerSendHighlightedBackgroundColor];
        _originalBtn.isSelect = YES;
        
        __block double allSize = 0.0;
        __block BOOL isContainsLoading = NO;
        
        if ([BKImagePicker sharedManager].imageManageModel.max_select == 1) {
            BKImageModel * model = self.imageListArray[selectIndex==INT_MAX?_currentImageIndex:selectIndex];
            allSize = model.originalImageSize;
        }else{
            [[BKImagePicker sharedManager].imageManageModel.selectImageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                BKImageModel * model = obj;
                allSize = allSize + model.originalImageSize;
                if (model.loadingProgress != 1) {
                    isContainsLoading = YES;
                    *stop = YES;
                }
            }];
        }
        
        if (isContainsLoading) {
            [_originalBtn setTitle:@"原图(计算中)"];
        }else{
            if (allSize>1024) {
                allSize = allSize / 1024;
                if (allSize > 1024) {
                    allSize = allSize / 1024;
                    [_originalBtn setTitle:[NSString stringWithFormat:@"原图(%.1fT)",allSize]];
                }else{
                    [_originalBtn setTitle:[NSString stringWithFormat:@"原图(%.1fG)",allSize]];
                }
            }else{
                [_originalBtn setTitle:[NSString stringWithFormat:@"原图(%.1fM)",allSize]];
            }
        }
        
    }else{
        [_originalBtn setTitleColor:BKImagePickerSendTitleNormalColor];
        _originalBtn.isSelect = NO;
        [_originalBtn setTitle:@"原图"];
    }
}

-(void)sendBtnClick:(UIButton*)button
{
    if ([[BKImagePicker sharedManager].imageManageModel.selectImageArray count] == 0) {
        
        BKImageModel * model = _imageListArray[_currentImageIndex];
        if (model.loadingProgress != 1) {
            [self.view bk_showRemind:BKSelectImageDownloadingRemind];
            return;
        }
        
        [[BKImagePicker sharedManager].imageManageModel.selectImageArray addObject:model];
        
    }else{
        
        __block BOOL isContainsLoading = NO;
        [[BKImagePicker sharedManager].imageManageModel.selectImageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BKImageModel * imageModel = obj;
            if (imageModel.loadingProgress != 1) {
                isContainsLoading = YES;
                *stop = YES;
            }
        }];
        
        if (isContainsLoading == YES) {
            [self.view bk_showRemind:BKSelectImageDownloadingRemind];
            return;
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BKFinishSelectImageNotification object:nil userInfo:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UICollectionView

-(UICollectionView*)exampleImageCollectionView
{
    if (!_exampleImageCollectionView) {
        
        BKImagePreviewCollectionViewFlowLayout * flowLayout = [[BKImagePreviewCollectionViewFlowLayout alloc]init];
        flowLayout.allImageCount = [self.imageListArray count];
        
        _exampleImageCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _exampleImageCollectionView.delegate = self;
        _exampleImageCollectionView.dataSource = self;
        _exampleImageCollectionView.backgroundColor = BKClearColor;
        _exampleImageCollectionView.showsVerticalScrollIndicator = NO;
        _exampleImageCollectionView.showsHorizontalScrollIndicator = NO;
        _exampleImageCollectionView.pagingEnabled = YES;
        _exampleImageCollectionView.hidden = YES;
        if (@available(iOS 11.0, *)) {
            _exampleImageCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        [_exampleImageCollectionView registerClass:[BKImagePreviewCollectionViewCell class] forCellWithReuseIdentifier:@"BKImagePreviewCollectionViewCell"];
        
        UITapGestureRecognizer * exampleImageCollectionViewTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(exampleImageCollectionViewTapRecognizer)];
        [_exampleImageCollectionView addGestureRecognizer:exampleImageCollectionViewTapRecognizer];
        
        [self.view insertSubview:_exampleImageCollectionView atIndex:0];
        
        [_exampleImageCollectionView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _exampleImageCollectionView;
}

-(void)exampleImageCollectionViewTapRecognizer
{
    self.statusBarHidden = !self.statusBarHidden;
    if (self.statusBarHidden) {
        self.topNavView.alpha = 0;
        self.bottomNavView.alpha = 0;
        
        self.interactiveTransition.isNavHidden = YES;
    }else{
        self.topNavView.alpha = 0.8;
        self.bottomNavView.alpha = 0.8;
        
        self.interactiveTransition.isNavHidden = NO;
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.imageListArray count];
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BKImagePreviewCollectionViewCell * cell = (BKImagePreviewCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"BKImagePreviewCollectionViewCell" forIndexPath:indexPath];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    BKImagePreviewCollectionViewCell * currentCell = (BKImagePreviewCollectionViewCell*)cell;
    
    currentCell.imageScrollView.zoomScale = 1;
    currentCell.imageScrollView.contentSize = CGSizeMake(currentCell.bk_width-BKExampleImagesSpacing*2, currentCell.bk_height);
    
    BKImageModel * model = self.imageListArray[indexPath.item];
    
    if (model.loadingProgress > 0 && model.loadingProgress < 1) {
        [currentCell bk_showLoadLayerWithDownLoadProgress:model.loadingProgress];
    }else{
        [currentCell bk_hideLoadLayer];
    }
    
    _currentOriginalImageLoadedFlag = NO;
    
    if (model.loadingProgress == 1) {
        
        [self editImageView:currentCell.showImageView image:[UIImage imageWithData:model.originalImageData] imageData:nil scrollView:currentCell.imageScrollView];
        
        self.currentOriginalImageLoadedFlag = YES;
        
    }else{
        if (model.thumbImage) {
            [self editImageView:currentCell.showImageView image:model.thumbImage imageData:nil scrollView:currentCell.imageScrollView];
            [[BKImagePicker sharedManager] getOriginalImageWithAsset:model.asset complete:^(UIImage *originalImage) {
                [self editImageView:currentCell.showImageView image:originalImage imageData:nil scrollView:currentCell.imageScrollView];
                
                self.currentOriginalImageLoadedFlag = YES;
            }];
        }else{
            [[BKImagePicker sharedManager] getThumbImageWithAsset:model.asset complete:^(UIImage *thumbImage) {
                model.thumbImage = thumbImage;
                [self editImageView:currentCell.showImageView image:thumbImage imageData:nil scrollView:currentCell.imageScrollView];
                
                [[BKImagePicker sharedManager] getOriginalImageWithAsset:model.asset complete:^(UIImage *originalImage) {
                    [self editImageView:currentCell.showImageView image:originalImage imageData:nil scrollView:currentCell.imageScrollView];
                    
                    self.currentOriginalImageLoadedFlag = YES;
                }];
            }];
        }
    }
}

-(void)loadingOriginalImageDataWithSelectIndexPath:(NSIndexPath*)selectIndexPath
{
    NSIndexPath * currentIndexPath = nil;
    if (!selectIndexPath) {
        currentIndexPath = [NSIndexPath indexPathForItem:_currentImageIndex inSection:0];
    }else{
        currentIndexPath = selectIndexPath;
    }
    BOOL flag = [_exampleImageCollectionView.indexPathsForVisibleItems containsObject:currentIndexPath];
    
    while (!flag || !_currentOriginalImageLoadedFlag) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loadingOriginalImageDataWithSelectIndexPath:selectIndexPath];
        });
        return;
    }
    
    BKImagePreviewCollectionViewCell * currentCell = (BKImagePreviewCollectionViewCell*)[_exampleImageCollectionView cellForItemAtIndexPath:currentIndexPath];
    
    self.interactiveTransition.startImageView = currentCell.showImageView;
    self.interactiveTransition.supperScrollView = currentCell.imageScrollView;
    
    BKImageModel * model = self.imageListArray[currentIndexPath.item];
    
    if (model.loadingProgress == 1) {
        
        if (model.photoType == BKSelectPhotoTypeGIF) {
            if (![model.originalImageData isEqualToData:currentCell.showImageView.animatedImage.data]) {
                [self editImageView:currentCell.showImageView image:nil imageData:model.originalImageData scrollView:currentCell.imageScrollView];
            }
        }
        
    }else{
        [[BKImagePicker sharedManager] getOriginalImageDataWithAsset:model.asset progressHandler:^(double progress, NSError *error, PHImageRequestID imageRequestID) {
            
            if (error) {
                [currentCell bk_hideLoadLayer];
                model.loadingProgress = 0;
                return;
            }
            
            [currentCell bk_showLoadLayerWithDownLoadProgress:progress];
            model.loadingProgress = progress;
            
        } complete:^(NSData *originalImageData, NSURL *url, PHImageRequestID imageRequestID) {
            
            [currentCell bk_hideLoadLayer];
            
            if (originalImageData) {
                
                model.originalImageData = originalImageData;
                model.loadingProgress = 1;
                
                if (model.photoType == BKSelectPhotoTypeGIF) {
                    [self editImageView:currentCell.showImageView image:nil imageData:model.originalImageData scrollView:currentCell.imageScrollView];
                }
                
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    model.thumbImageData = [[BKImagePicker sharedManager] compressImageData:originalImageData];
                });
                model.url = url;
                model.originalImageSize = (double)originalImageData.length/1024/1024;
               
                [self calculataImageSizeWithSelectIndex:currentIndexPath.item];
                [self refreshBottomNavBtnStateWithSelectIndex:currentIndexPath.item];
               
            }else{
                model.loadingProgress = 0;
                
                NSArray * visibleIndexPathArr = [self.exampleImageCollectionView indexPathsForVisibleItems];
                [visibleIndexPathArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSIndexPath * indexPath = obj;
                    if (indexPath.item == currentIndexPath.item && indexPath.section == currentIndexPath.section) {
                        [self.view bk_showRemind:BKOriginalImageDownloadFailedRemind];
                        *stop = YES;
                    }
                }];
                
                [self calculataImageSizeWithSelectIndex:currentIndexPath.item];
                [self refreshBottomNavBtnStateWithSelectIndex:currentIndexPath.item];
                
            }
            
        }];
    }
    
    [self calculataImageSizeWithSelectIndex:currentIndexPath.item];
    [self refreshBottomNavBtnStateWithSelectIndex:currentIndexPath.item];
}

#pragma mark - 整合image与imageView

/**
 修改图frame
 
 @param showImageView   image所在的imageVIew
 @param image           image
 @param imageData       imageData
 @param imageScrollView image所在的scrollView
 */
-(void)editImageView:(FLAnimatedImageView*)showImageView image:(UIImage*)image imageData:(NSData*)imageData scrollView:(UIScrollView*)imageScrollView
{
    if (!imageData && !image) {
        return;
    }
    
    if (image) {
        showImageView.image = image;
    }
    
    if (imageData) {
        FLAnimatedImage * gifImage = [FLAnimatedImage animatedImageWithGIFData:imageData];
        if (gifImage) {
            showImageView.animatedImage = gifImage;
        }else{
            showImageView.image = [UIImage imageWithData:imageData];
        }
    }
    
    showImageView.frame = [self calculateTargetFrameWithImageView:showImageView];
    imageScrollView.contentSize = CGSizeMake(showImageView.bk_width, showImageView.bk_height);
    
    CGFloat scale = image.size.width / self.view.bk_width;
    imageScrollView.maximumZoomScale = scale<2?2:scale;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _exampleImageCollectionView) {
        if (_isLoadOver) {
            
            CGPoint point = [self.view convertPoint:self.exampleImageCollectionView.center toView:self.exampleImageCollectionView];
            NSIndexPath * currentIndexPath = [self.exampleImageCollectionView indexPathForItemAtPoint:point];
            
            self.currentImageIndex = currentIndexPath.item;
            
            BOOL flag = [_exampleImageCollectionView.indexPathsForVisibleItems containsObject:currentIndexPath];
            if (flag) {
                BKImagePreviewCollectionViewCell * currentCell = (BKImagePreviewCollectionViewCell*)[_exampleImageCollectionView cellForItemAtIndexPath:currentIndexPath];
                
                self.interactiveTransition.startImageView = currentCell.showImageView;
                self.interactiveTransition.supperScrollView = currentCell.imageScrollView;
            }
        }
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSIndexPath * selectIndexPath = [self.exampleImageCollectionView indexPathForItemAtPoint:*targetContentOffset];
    if (scrollView == _exampleImageCollectionView) {
        [self loadingOriginalImageDataWithSelectIndexPath:selectIndexPath];
    }
}

#pragma mark - KVO

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"currentImageIndex"]) {
        
        if ([change[@"old"] integerValue] == [change[@"new"] integerValue]) {
            return;
        }
        
        self.titleLab.text = [NSString stringWithFormat:@"%ld/%ld",_currentImageIndex+1,[self.imageListArray count]];
        
        BKImageModel * model = self.imageListArray[_currentImageIndex];
        if (self.delegate) {
            [self.delegate refreshLookLocationActionWithImageModel:model];
        }
        
        self.rightNavBtn.title = @"";
        [[BKImagePicker sharedManager].imageManageModel.selectImageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BKImageModel * selectModel = obj;
            if ([model.fileName isEqualToString:selectModel.fileName]) {
                self.rightNavBtn.title = [NSString stringWithFormat:@"%ld",idx+1];
                *stop = YES;
            }
        }];
        
    }else if ([keyPath isEqualToString:@"contentSize"]) {
        
        CGFloat contentOffX = (self.view.bk_width+BKExampleImagesSpacing*2) * _currentImageIndex;
        if (_exampleImageCollectionView.contentSize.width - _exampleImageCollectionView.bk_width >= contentOffX) {
            [_exampleImageCollectionView setContentOffset:CGPointMake(contentOffX, 0) animated:NO];
        }
        
        [_exampleImageCollectionView removeObserver:self forKeyPath:@"contentSize"];
        _isLoadOver = YES;
        
        [self loadingOriginalImageDataWithSelectIndexPath:nil];
    }
}

@end


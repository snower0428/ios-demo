#import <UIKit/UIKit.h>

@protocol ProgressViewDelegate;

@interface ProgressView : UIAlertView <UIAlertViewDelegate>
{
	UIProgressView *m_progressView;
	UILabel *m_progressLabel;
	UIActivityIndicatorView *m_activityView;
	int m_totalSize;
	int m_dlSize;
	id _progressViewDelegate;
}

@property(nonatomic, assign) id<ProgressViewDelegate> progressViewDelegate;

- (id)initWithTitle:(NSString *)title;
- (void)setCurTitle:(NSString *)str;
- (void)setProgress:(int)progress;
- (void)setTotalSize:(int)size;
- (void)setDownloadSize:(int)size;
- (void)closeView;

@end


@protocol ProgressViewDelegate<NSObject>

@optional

- (void)progressViewClickCancelBtn;

@end

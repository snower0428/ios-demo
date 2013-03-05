
#include "ProgressView.h"


@implementation ProgressView

@synthesize progressViewDelegate = _progressViewDelegate;

#define MAX_BUFFER 1024

- (id)initWithTitle:(NSString *)title
{
    if (self = [super init]) 
	{
		self.title = title;
		self.delegate = self;
		
		m_progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(34, 40, 220, 20)];
		m_progressView.progress = 0.0f;
		m_progressView.progressViewStyle = UIProgressViewStyleBar;
		[self addSubview:m_progressView];
	
		m_totalSize = 0;
		m_dlSize = 0;
		
		m_progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 52, 180, 26)];
		m_progressLabel.font = [UIFont fontWithName:@"Arial" size:15.0f];
		m_progressLabel.textAlignment = UITextAlignmentCenter;
		m_progressLabel.text = @" ";
		m_progressLabel.textColor = [UIColor whiteColor];
		m_progressLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:m_progressLabel];
		
		m_activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(230, 18, 18, 18)];
		[m_activityView startAnimating];
		[self addSubview:m_activityView];
		
		self.message = @"\n";
		NSString *btnTitle = [[NSBundle mainBundle] localizedStringForKey:@"Cancel" value:@"取消" table:nil];
		[self addButtonWithTitle:btnTitle];
    }
	
    return self;
}

- (void)setCurTitle:(NSString *)str
{
	[self performSelectorOnMainThread:@selector(setTitle:) withObject:str waitUntilDone:NO];
}

- (void)setProgress:(int)progress
{
	if (progress < 0 || progress > 100) 
	{
		progress = 0;
	}
	
	m_progressView.progress = progress / 100.0f;
	
	// update download indicator's text
	char buf[MAX_BUFFER];
	memset(buf, '\0', MAX_BUFFER);
	
	if (m_dlSize > 1000000) 
	{
		snprintf(buf, MAX_BUFFER-1, "%.2fM / ", m_dlSize / 1000000.0f);
	} 
	else if (m_dlSize > 1000) 
	{
		snprintf(buf, MAX_BUFFER-1, "%.2fK / ", m_dlSize / 1000.0f);
	} 
	else 
	{
		snprintf(buf, MAX_BUFFER-1, "%.2fB / ", m_dlSize / 1.0f);
	}
	
	char tmp[MAX_BUFFER];
	memset(tmp, '\0', MAX_BUFFER);
	
	if (m_totalSize > 1000000) 
	{
		snprintf(tmp, MAX_BUFFER-1, "%.2fM", m_totalSize / 1000000.0f);
	} 
	else if (m_totalSize > 1000) 
	{
		snprintf(tmp, MAX_BUFFER-1, "%.2fK", m_totalSize / 1000.0f);
	} 
	else 
	{
		snprintf(tmp, MAX_BUFFER-1, "%.2fB", m_totalSize / 1.0f);
	}
	
	strcat(buf, tmp);
	m_progressLabel.text = [NSString stringWithUTF8String:buf];
}

- (void)setTotalSize:(int)size
{
	if (size < 0) 
	{
		size = 0;
	}
	m_totalSize = size;
}

- (void)setDownloadSize:(int)size
{
	if (size < 0) 
	{
		size = 0;
	}
	m_dlSize = size;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)
	{
		if ([_progressViewDelegate respondsToSelector:@selector(progressViewClickCancelBtn)])
		{
			[_progressViewDelegate progressViewClickCancelBtn];
		}
	}
}

- (void)closeView
{
	[self dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)dealloc
{
	[m_progressView release];
	[m_progressLabel release];
	[m_activityView stopAnimating];
	[m_activityView release];
	
    [super dealloc];
}

@end

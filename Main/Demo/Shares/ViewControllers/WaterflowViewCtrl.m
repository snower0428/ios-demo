//
//  WaterflowViewCtrl.m
//  Demo
//
//  Created by leihui on 13-4-10.
//
//

#import "WaterflowViewCtrl.h"
#import "AsyncImageView.h"

@interface WaterflowViewCtrl ()

@end

@implementation WaterflowViewCtrl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, APP_VIEW_HEIGH)];
    view.backgroundColor = [UIColor grayColor];
    self.view = view;
    [view release];
    
    _waterflowView = [[WaterflowView alloc] initWithFrame:self.view.bounds];
    _waterflowView.flowdatasource = self;
    _waterflowView.flowdelegate = self;
    [self.view addSubview:_waterflowView];
    
    _imageUrls = [[NSArray arrayWithObjects:
                  @"http://img.topit.me/l/201008/11/12815218412635.jpg",
                  @"http://photo.l99.com/bigger/22/1284013907276_zb834a.jpg",
                  @"http://www.webdesign.org/img_articles/7072/BW-kitten.jpg",
                  @"http://www.raiseakitten.com/wp-content/uploads/2012/03/kitten.jpg",
                  @"http://imagecache6.allposters.com/LRG/21/2144/C8BCD00Z.jpg",nil] retain];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_waterflowView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WaterflowDataSource

- (NSInteger)numberOfColumnsInFlowView:(WaterflowView *)flowView
{
    return 3;
}

- (NSInteger)flowView:(WaterflowView *)flowView numberOfRowsInColumn:(NSInteger)column
{
    return 6;
}

- (WaterFlowCell *)flowView:(WaterflowView *)flowView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
	WaterFlowCell *cell = [flowView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if(cell == nil)
	{
		cell  = [[[WaterFlowCell alloc] initWithReuseIdentifier:CellIdentifier] autorelease];
		
		AsyncImageView *imageView = [[AsyncImageView alloc] initWithFrame:CGRectZero];
		[cell addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleToFill;
		imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
		imageView.layer.borderWidth = 1;
		[imageView release];
		imageView.tag = 1001;
	}
	
	float height = [self flowView:nil heightForRowAtIndexPath:indexPath];
	
	AsyncImageView *imageView  = (AsyncImageView *)[cell viewWithTag:1001];
	imageView.frame = CGRectMake(0, 0, self.view.frame.size.width / 3, height);
    [imageView loadImage:[_imageUrls objectAtIndex:(indexPath.row + indexPath.section) % 5]];
	
	return cell;
    
}

#pragma mark - WaterflowDelegate

-(CGFloat)flowView:(WaterflowView *)flowView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
	float height = 0;
	switch ((indexPath.row + indexPath.section )  % 5) {
		case 0:
			height = 127;
			break;
		case 1:
			height = 100;
			break;
		case 2:
			height = 87;
			break;
		case 3:
			height = 114;
			break;
		case 4:
			height = 140;
			break;
		case 5:
			height = 158;
			break;
		default:
			break;
	}
	
	height += indexPath.row + indexPath.section;
	
	return height;
    
}

- (void)flowView:(WaterflowView *)flowView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"did select at indexPath:%@",indexPath);
}

#pragma mark - dealloc

- (void)dealloc
{
    [_waterflowView release];
    [_imageUrls release];
    
    [super dealloc];
}

@end

//
//  ResultViewController.m
//  MyLog
//
//  Created by inoue on 2013/11/12.
//  Copyright (c) 2013年 inobo. All rights reserved.
//

#import "ResultViewController.h"


@interface ResultViewController (){

}



@end

@implementation ResultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.

    // Box2Dの世界を作る
	[self createPhysicsWorld];

    
    
    /*
    // 1列あたりに４つブロックをおける.
    int Log_count = [[LogConfiguration getLogs]count];
    
    float height =  ((Log_count/4)+1) *60;
    if(height < self.view.frame.size.height)
        height = self.view.frame.size.height;
    
    CGRect rect = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y,
                             self.view.frame.size.width, height);
    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:rect];
    
    for(int i=0;i<Log_count-1;i++){
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        int init_height = 10; // i/4+1
        int item_height = 50; // i/4+1 *2
        int first_height = init_height+item_height/2;
        int interval_height = first_height+item_height/2;
        view.center = CGPointMake(self.view.frame.size.width/5*(i%4+1),
                                       first_height+(i/4+1)*interval_height);
        view.backgroundColor = [UIColor yellowColor];
        
        CGRect label_rect = CGRectMake(5, 5, 40, 40);
        UILabel *label = [[UILabel alloc]initWithFrame:label_rect];
        label.text = [NSString stringWithFormat:@"%3d",i+1];
        [view addSubview:label];
        
        [scroll addSubview:view];
    }
    [self.view addSubview:scroll];
    
    //スクロールバーの値。アニメーション;
    int insert_index = ((Log_count+1)%4)+1; // 1 2 3 4
    */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // タイマーをスタート
	timer = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0 target:self selector:@selector(tick:) userInfo:nil repeats:YES];
}

-(void)createPhysicsWorld
{
	CGSize screenSize = self.view.bounds.size;
    
	// 重力
	b2Vec2 gravity;
	gravity.Set(0.0f, -9.81f);
    
	// ワールドオブジェクト
	world = new b2World(gravity);
	world->SetContinuousPhysics(true);
    
	b2BodyDef groundBodyDef;
	groundBodyDef.position.Set(0, 0); // bottom-left corner
	b2Body* groundBody = world->CreateBody(&groundBodyDef);
    
	b2EdgeShape groundBox;
    
	// bottom
	groundBox.Set(b2Vec2(0,0), b2Vec2(screenSize.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox, 0);
    
	// left
	groundBox.Set(b2Vec2(0,screenSize.height/PTM_RATIO), b2Vec2(0,0));
	groundBody->CreateFixture(&groundBox, 0);
    
	// right
	groundBox.Set(b2Vec2(screenSize.width/PTM_RATIO,screenSize.height/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox, 0);
}

-(void) tick:(NSTimer *)sender
{
    static float lastTime;
    if (lastTime > 0.2) {
        [self addNewBrick];
        lastTime = 0;
    }
    lastTime += sender.timeInterval;
    
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
    
	world->Step(1.0f/60.0f, velocityIterations, positionIterations);
    
	for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
	{
		if (b->GetUserData() != NULL)
		{
			UIView *oneView = (__bridge UIView *)b->GetUserData();
            
			// y Position subtracted because of flipped coordinate system
			CGPoint newCenter = CGPointMake(b->GetPosition().x * PTM_RATIO,
                                            self.view.bounds.size.height - b->GetPosition().y * PTM_RATIO);
			oneView.center = newCenter;
            
			CGAffineTransform transform = CGAffineTransformMakeRotation(- b->GetAngle());
            
			oneView.transform = transform;
		}
	}
}


- (void)addNewBrick
{
    float x = arc4random() % 320;
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    v.center = CGPointMake(x, 0);
    v.backgroundColor = [UIColor brownColor];
    v.layer.borderWidth = 1.0;
    v.layer.borderColor = [UIColor whiteColor].CGColor;
    v.layer.shadowOpacity = 0.01;
    [self.view addSubview:v];
    
    [self addPhysicalBodyForView:v];
}


-(void)addPhysicalBodyForView:(UIView *)physicalView
{
	// Define the dynamic body.
	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
    
	CGPoint p = physicalView.center;
	CGPoint boxDimensions = CGPointMake(physicalView.bounds.size.width/PTM_RATIO/2.0,physicalView.bounds.size.height/PTM_RATIO/2.0);
    
	bodyDef.position.Set(p.x/PTM_RATIO, (460.0 - p.y)/PTM_RATIO);
	bodyDef.userData =  (__bridge void *)physicalView;
    
	// Tell the physics world to create the body
	b2Body *body = world->CreateBody(&bodyDef);
    
	// Define another box shape for our dynamic body.
	b2PolygonShape dynamicBox;
    
	dynamicBox.SetAsBox(boxDimensions.x, boxDimensions.y);
    
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicBox;
	fixtureDef.density = 3.0f;
	fixtureDef.friction = 0.3f;
	fixtureDef.restitution = 0.5f; // 0 is a lead ball, 1 is a super bouncy ball
	body->CreateFixture(&fixtureDef);
    
	// a dynamic body reacts to forces right away
	body->SetType(b2_dynamicBody);
    
	// we abuse the tag property as pointer to the physical body
	physicalView.tag = (int)body;
}

@end

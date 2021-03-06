//
//  BasePOIMapViewController.m
//  BaseProject
//
//  Created by 舒通 on 2017/9/13.
//  Copyright © 2017年 舒通. All rights reserved.
//

#import "BasePOIMapViewController.h"
#import "BaseSearchBarView.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "POIAnnotation.h"


@interface BasePOIMapViewController ()<MAMapViewDelegate, AMapSearchDelegate, AMapLocationManagerDelegate>
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, copy) NSString *currentAddress;//当前位置
@property (nonatomic, assign) BOOL isCurrentCenter;//是否以当前位置为中心点
@end

@implementation BasePOIMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"地点设置";
    [self createSearchView];
    [self configLocationManager];
    [self createMapView];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self stopSerialLocation];
}
- (void)dealloc
{
    [self stopSerialLocation];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark  ************** tableView data **************
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [NSString stringWithFormat:@"我的位置-%@",[self.dataSource[indexPath.row] name]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_chooseAddress) {
        _chooseAddress([self.dataSource[indexPath.row] name]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark  ************** MAMapViewDelegate **************
//标注view的calloutview整体点击时，触发改回调。
- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    id<MAAnnotation> annotation = view.annotation;
    
    if ([annotation isKindOfClass:[POIAnnotation class]])
    {
        if (_chooseAddress) {
            _chooseAddress(annotation.title);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[POIAnnotation class]])
    {
        static NSString *poiIdentifier = @"poiIdentifier";
        MAPinAnnotationView *poiAnnotationView = (MAPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:poiIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:poiIdentifier];
        }
        
        poiAnnotationView.canShowCallout = YES;
        poiAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        return poiAnnotationView;
    }
    
    return nil;
}

#pragma mark - AMapSearchDelegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
}

/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    if (response.pois.count == 0)
    {
        return;
    }
    
    NSMutableArray *poiAnnotations = [NSMutableArray arrayWithCapacity:response.pois.count];
    [self.dataSource addObjectsFromArray:response.pois];
//    [self.tableView reloadData];
    [self createTableView];
    
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        [poiAnnotations addObject:[[POIAnnotation alloc] initWithPOI:obj]];
        
    }];
    
    /* 将结果以annotation的形式加载到地图上. */
    [self.mapView addAnnotations:poiAnnotations];
    
    /* 如果只有一个结果，设置其为中心点. */
    if (poiAnnotations.count == 1)
    {
        [self.mapView setCenterCoordinate:[poiAnnotations[0] coordinate]];
    }
    /* 如果有多个结果, 设置地图使所有的annotation都可见. */
    else
    {
        if (self.isCurrentCenter) {
           [self.mapView showAnnotations:poiAnnotations animated:NO];
        }
        self.isCurrentCenter = YES;
    }
}

#pragma mark - Utility
/* 根据关键字来搜索POI. */
- (void)searchPoiByKeyword:(NSString *)keyword
{
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.keywords = keyword;
    //
    //    /*  搜索SDK 3.2.0 中新增加的功能，只搜索本城市的POI。*/
    //    request.cityLimit           = YES;
    request.requireSubPOIs      = YES;
    
    [self.search AMapPOIKeywordsSearch:request];
}
#pragma mark  ************** 定位相关 **************
- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    self.locationManager.distanceFilter = 200;
    [self.locationManager setLocatingWithReGeocode:YES];
    [self startSerialLocation];
}

- (void)startSerialLocation
{
    //开始定位
    [self.locationManager startUpdatingLocation];
}

- (void)stopSerialLocation
{
    //停止定位
    [self.locationManager stopUpdatingLocation];
}

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    //定位错误
    DLog(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)];
    DLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    if (reGeocode)
    {
        if (![NSString isBlankString:reGeocode.formattedAddress]) {
            self.currentAddress = reGeocode.formattedAddress;
        } else {
            self.currentAddress = [NSString stringWithFormat:@"%@%@%@%@%@",reGeocode.province,reGeocode.city,reGeocode.district,reGeocode.street,reGeocode.number];
        }
        if (!self.isCurrentCenter) {
            [self searchPoiByKeyword:self.currentAddress];
        }
        DLog(@"reGeocode:%@", reGeocode);
    }
}
#pragma mark  ************** create UI **************
- (void)createSearchView
{
    BaseSearchBarView *searchView = [[BaseSearchBarView alloc]initWithFrame:CGRectMake(20, 0, KScreenWidth-40, 44)];
    searchView.placeString = @"输入关键字";
    kWS(weakSelf)
    searchView.searchText = ^(NSString *text) {
        DLog(@"shu ru de wen zi = %@",text);
        [weakSelf searchPoiByKeyword:text];
    };
    [self.view addSubview:searchView];
}
- (void)createMapView
{
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0 + 44, KScreenWidth, KScreenHeight - NavHeight - 44)];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapView.delegate = self;
    [self.mapView setZoomLevel:16.1 animated:YES];
    self.mapView.showsUserLocation = YES;
    
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    self.mapView.rotateEnabled= NO;    //NO表示禁用旋转手势，YES表示开启
    
    self.mapView.rotateCameraEnabled= NO;
    [self.view addSubview:self.mapView];
    
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
}

- (void)createTableView
{
    self.tableView.y = KScreenHeight - 40*3;
    self.tableView.height = 40*3;
    [self.view addSubview:self.tableView];
}
@end

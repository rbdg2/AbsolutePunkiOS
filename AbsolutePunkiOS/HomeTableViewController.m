//
//  HomeTableViewController.m
//  AbsolutePunkiOS
//
//  Created by RB de Guzman on 9/28/15.
//  Copyright (c) 2015 RB de Guzman. All rights reserved.
//

#import "HomeTableViewController.h"
#import "KeyParser.h"

#import "APItemTableViewCell.h"

@interface HomeTableViewController () <NSXMLParserDelegate>
@property (nonatomic, strong) NSMutableArray *items;

//XML Parsing Properties
@property (nonatomic, strong) NSXMLParser *parser;
@property (nonatomic, strong) NSMutableDictionary *item;
@property (nonatomic, strong) NSString *currentElement;
@property (nonatomic, strong) NSMutableString *currentTitle;
@property (nonatomic, strong) NSMutableString *currentLink;
@property (nonatomic, strong) NSMutableString *currentDescription;
@property (nonatomic, strong) NSMutableString *currentPubDate;

//APItemTableViewCell
@property (nonatomic, assign) CGFloat heightForRow;
@end

@implementation HomeTableViewController

#pragma mark - ViewController Load Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self parseXMLFileAtURL:[NSURL URLWithString:KEY_URL_RSS]];
    
}

#pragma mark - NSXMLParser Method
- (void)parseXMLFileAtURL:(NSURL *)url {    
    self.parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [self.parser setDelegate:self];
    
    [self.parser setShouldProcessNamespaces:NO];
    [self.parser setShouldReportNamespacePrefixes:NO];
    [self.parser setShouldResolveExternalEntities:NO];
    
    [self.parser parse];
}

#pragma mark - NSXMLParserDelegate Methods
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    self.items = [[NSMutableArray alloc] init];
    
    NSLog(@"APiOS parserDidStartDocument");
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"APiOS parseErrorOccurred %@", parseError);
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    self.currentElement = [elementName copy];
    
    if ([elementName isEqualToString:KEY_STR_ITEM]) {
        self.item = [[NSMutableDictionary alloc] init];
        self.currentTitle = [[NSMutableString alloc] init];
        self.currentLink = [[NSMutableString alloc] init];
        self.currentDescription = [[NSMutableString alloc] init];
        self.currentPubDate = [[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ([self.currentElement isEqualToString:KEY_STR_TITLE]) {
        [self.currentTitle appendString:string];
        
    } else if([self.currentElement isEqualToString:KEY_STR_LINK]) {
        [self.currentLink appendString:string];
        
    } else if ([self.currentElement isEqualToString:KEY_STR_DESCRIPTION]) {
        [self.currentDescription appendString:string];
        
    } else if ([self.currentElement isEqualToString:KEY_STR_PUBDATE]) {
        [self.currentPubDate appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:KEY_STR_ITEM]) {
        [self.item setObject:self.currentTitle forKey:KEY_STR_TITLE];
        [self.item setObject:self.currentLink  forKey:KEY_STR_LINK];
        [self.item setObject:self.currentDescription forKey:KEY_STR_DESCRIPTION];
        [self.item setObject:self.currentPubDate forKey:KEY_STR_PUBDATE];
        
        [self.items addObject:[self.item copy]];
//        NSLog(@"adding Item: %@", self.currentTitle);
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [self.tableView reloadData];
    NSLog(@"APiOS parserDidEndDocument");
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    APItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[APItemTableViewCell reuseIdentifier]];
    
    if (cell == nil) {
        cell = [APItemTableViewCell loadNib];
    }
    
    NSDictionary *item = self.items[indexPath.row];
    cell.titleLabel.text = (NSString *)[item objectForKey:KEY_STR_TITLE];
    cell.subtitleLabel.text = (NSString *)[item objectForKey:KEY_STR_PUBDATE];
    return cell;
}

#pragma mark - UITableViewDelegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.heightForRow == 0) {
        APItemTableViewCell *cell = [APItemTableViewCell loadNib];
        self.heightForRow = cell.frame.size.height;
    }
    
    return self.heightForRow;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = self.items[indexPath.row];
    NSString *urlString = (NSString *)[item objectForKey:KEY_STR_LINK];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"redirecting to URL: %@", urlString);
  
    NSURL *url = [NSURL URLWithString:urlString];
    
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    } else {
        NSLog(@"RB_DEBUG cannot open");
    }
}

@end

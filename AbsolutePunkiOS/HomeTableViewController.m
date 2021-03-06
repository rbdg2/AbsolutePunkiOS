//
//  HomeTableViewController.m
//  AbsolutePunkiOS
//
//  Created by RB de Guzman on 9/28/15.
//  Copyright (c) 2015 RB de Guzman. All rights reserved.
//

#import "HomeTableViewController.h"

@interface HomeTableViewController () <NSXMLParserDelegate>
@property (nonatomic, strong) NSMutableArray *items;

//XML Parsing Properties
@property (nonatomic, strong) NSXMLParser *parser;
@property (nonatomic, strong) NSMutableDictionary *item;
@property (nonatomic, strong) NSString* currentElement;
@property (nonatomic, strong) NSMutableString *currentTitle;
@property (nonatomic, strong) NSMutableString *currentLink;
@end

@implementation HomeTableViewController

#pragma mark - ViewController Load Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *urlString = @"http://www.absolutepunk.net/rss";
    [self parseXMLFileAtURL:urlString];
    
}

#pragma mark - NSXMLParser Method
- (void)parseXMLFileAtURL:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    
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

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [self.tableView reloadData];
    NSLog(@"APiOS parserDidEndDocument");
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"APiOS parseErrorOccurred %@", parseError);
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    self.currentElement = [elementName copy];
    
    if ([elementName isEqualToString:@"item"]) {
        self.item = [[NSMutableDictionary alloc] init];
        self.currentTitle = [[NSMutableString alloc] init];
        self.currentLink = [[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ([self.currentElement isEqualToString:@"title"]) {
        [self.currentTitle appendString:string];
    } else if([self.currentElement isEqualToString:@"link"]) {
        [self.currentLink appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"item"]) {
        [self.item setObject:self.currentTitle forKey:@"title"];
        [self.item setObject:self.currentLink  forKey:@"link"];

        [self.items addObject:[self.item copy]];
        NSLog(@"adding Item: %@", self.currentTitle);
    }
    
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newsCell"];
    
    NSDictionary *item = self.items[indexPath.row];
    cell.textLabel.text = (NSString *)[item objectForKey:@"title"];
    return cell;
}

#pragma mark - UITableViewDelegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = self.items[indexPath.row];
    NSString *urlString = (NSString *)[item objectForKey:@"link"];
    
    NSLog(@"redirecting to URL: %@", urlString);
  
    NSURL *url = [NSURL URLWithString:urlString];
    
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    } else {
        NSLog(@"RB_DEBUG cannot open");
    }
}

@end

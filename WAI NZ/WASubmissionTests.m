//
//  WASubmissionTests.m
//  WAI NZ
//
//  Created by Ashleigh Cains on 12/09/2012.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import "WASubmissionTests.h"
#import "WASubmission.h"
#import "WASubmissionPhoto.h"


@interface WASubmission (TestPrivate)
- (int)numberOfSubmissionPhotos;
- (WASubmissionPhoto *)submissionPhotoAtIndex:(int)index;

- (void)addTag:(NSString *)tag;
- (void)removeTag: (NSString *)tag;
- (NSString *)tagAtIndex:(int)index;
- (int)numberOfTags;
-(BOOL) containsTag:(NSString *)tag;
- (NSString *)tagsAsString ;

- (void)setDescriptionText:(NSString *)_descriptionText;

- (void)setAnonymous:(BOOL)_anonymous;


@end

@implementation WASubmissionTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
	[super tearDown];
}
 
- (void) testPhotoCount {
    WASubmission *testSubmission = [[WASubmission alloc] init];
    WASubmissionPhoto *firstPhoto = [[WASubmissionPhoto alloc] initWithPhoto:nil timestamp:100000 location:nil];
    WASubmissionPhoto *secondPhoto = [[WASubmissionPhoto alloc] initWithPhoto:nil timestamp:143200 location:nil];
    
    int count = [testSubmission numberOfSubmissionPhotos];
    
    STAssertTrue( count ==0, @"Expected 0, but got %d",count);
    
    [testSubmission addSubmissionPhoto:firstPhoto];
    count = [testSubmission numberOfSubmissionPhotos];
    STAssertTrue( count==1, @"Expected 1, but got %d",count);
    
    [testSubmission addSubmissionPhoto:secondPhoto];
    count = [testSubmission numberOfSubmissionPhotos];
    STAssertTrue( count == 2, @"Expected 1, but got %d", count);
    
}
 

- (void) testPhotoIndex {
    WASubmission *testSubmission = [[WASubmission alloc] init];
    WASubmissionPhoto *firstPhoto = [[WASubmissionPhoto alloc] initWithPhoto:nil timestamp:100000 location:nil];
    
    [testSubmission addSubmissionPhoto:firstPhoto];
    int count = [testSubmission numberOfSubmissionPhotos];
    NSLog(@"count of photos: %d", count);
    WASubmissionPhoto *photo = [testSubmission submissionPhotoAtIndex:0];
    
    STAssertEqualObjects(photo, firstPhoto, @"Expected the photos to be the same");
    
    
}



-(void) testAddTagNumberOfTags{
    WASubmission *testSubmission = [[WASubmission alloc] init];
    NSString *tag = @"Cow";
    
    STAssertTrue([testSubmission numberOfTags] ==0, @"Expected 0, but got %d",[testSubmission numberOfTags]);
    
    [testSubmission addTag:tag];
    
    STAssertTrue([testSubmission numberOfTags] ==1, @"Expected 1, but got %d",[testSubmission numberOfTags]);
}


-(void) testAddTagAtIndex{
    WASubmission *testSubmission = [[WASubmission alloc] init];
    NSString *tag = @"Cow";
    
    STAssertTrue([testSubmission numberOfTags] ==0, @"Expected 0, but got %d",[testSubmission numberOfTags]);
    
    [testSubmission addTag:tag];
    
    STAssertTrue([testSubmission numberOfTags] ==1, @"Expected 1, but got %d",[testSubmission numberOfTags]);
    
    NSString *result = [testSubmission tagAtIndex:0];
    STAssertFalse(result == nil, @"Expected a string ");
    
    STAssertEqualObjects(result, tag, @"Expected strings to be equal");
}

-(void) testAddTagContains{
    WASubmission *testSubmission = [[WASubmission alloc] init];
    NSString *tag = @"Cow";
    
    [testSubmission addTag:tag];
    
    STAssertTrue([testSubmission numberOfTags] ==1, @"Expected 1, but got %d",[testSubmission numberOfTags]);
    
    STAssertTrue([testSubmission containsTag:tag], @"Expected the submission to contain the tag %s", tag);
   
}

-(void) testRemoveTag{
    WASubmission *testSubmission = [[WASubmission alloc] init];
    NSString *tag = @"Cow";
    
    [testSubmission addTag:tag];
    
    STAssertTrue([testSubmission numberOfTags] ==1, @"Expected 1, but got %d",[testSubmission numberOfTags]);
    
    STAssertTrue([testSubmission containsTag:tag], @"Expected the submission to contain the tag %s", tag);
    
    [testSubmission removeTag:tag];
    
    STAssertTrue([testSubmission numberOfTags] ==0, @"Expected 0, but got %d",[testSubmission numberOfTags]);
    
    STAssertFalse([testSubmission containsTag:tag], @"Expected the submission to contain the tag %s", tag);
    
}

/*
 
 - (void)setDescriptionText:(NSString *)_descriptionText;
 
 - (void)setAnonymous:(BOOL)_anonymous;
 */

-(void) testTagsAsString{
    WASubmission *testSubmission = [[WASubmission alloc] init];
    NSString *tag = @"Cow";
    [testSubmission addTag:tag];
    
    STAssertTrue([testSubmission numberOfTags] ==1, @"Expected 1, but got %d",[testSubmission numberOfTags]);
    
    STAssertTrue([testSubmission containsTag:tag], @"Expected the submission to contain the tag %s", tag);
    
    NSString *result = [testSubmission tagsAsString];
    NSString *test = @"Cow";
    
    STAssertEqualObjects(result, test, @"tags from submission didnt match the string, result is: %s  and expected is: %s", result, test);
    
    NSString *tag2 = @"Runoff";
    [testSubmission addTag:tag2];
    test = @"Cow, Runoff";
    result = [testSubmission tagsAsString];
    
    STAssertEqualObjects(result, test, @"tags from submission didnt match the string, result is: %s  and expected is: %s", result, test);
}

-(void) testSetDescription {
    WASubmission *testSubmission = [[WASubmission alloc] init];
    
    STAssertTrue(testSubmission.descriptionText == nil, @"The description should be nil");
    
    NSString *desc = @"hi there";
    [testSubmission setDescriptionText:desc];
    
    STAssertFalse(testSubmission.descriptionText == nil, @"The description should be nil");
    }

-(void) testAnonymous{
    WASubmission *testSub = [[WASubmission alloc] init];
    
    STAssertFalse(testSub.anonymous, @"All submissions should initialise as true");
    
    [testSub setAnonymous:YES];
    
    STAssertTrue(testSub.anonymous, @"The submission anonimity should be changed to false");
    
}


@end

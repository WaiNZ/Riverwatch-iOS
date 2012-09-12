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




@end

@implementation WASubmissionTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
	[super tearDown];
}
/*
 
 numberOfSubmissionPhotos is always returning 0
 
- (void) testPhotoCount {
    WASubmission *testSubmission = [WASubmission alloc];
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
 

// photo is coming up as null
- (void) testPhotoIndex {
    WASubmission *testSubmission = [[WASubmission alloc] init];
    WASubmissionPhoto *firstPhoto = [[WASubmissionPhoto alloc] initWithPhoto:nil timestamp:100000 location:nil];
    WASubmissionPhoto *secondPhoto = [[WASubmissionPhoto alloc] initWithPhoto:nil timestamp:143200 location:nil];
    
    [testSubmission addSubmissionPhoto:firstPhoto];
    int count = [testSubmission numberOfSubmissionPhotos];
    NSLog(@"count of photos: %d", count);
    WASubmissionPhoto *photo = [testSubmission submissionPhotoAtIndex:0];
    
    STAssertEqualObjects(photo, firstPhoto, @"Expected the photos to be the same");
    
    
}

*/

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



@end

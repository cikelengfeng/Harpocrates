// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DXBaseEntity.h instead.

#import <CoreData/CoreData.h>


extern const struct DXBaseEntityAttributes {
	__unsafe_unretained NSString *aTimeStamp;
} DXBaseEntityAttributes;

extern const struct DXBaseEntityRelationships {
} DXBaseEntityRelationships;

extern const struct DXBaseEntityFetchedProperties {
} DXBaseEntityFetchedProperties;




@interface DXBaseEntityID : NSManagedObjectID {}
@end

@interface _DXBaseEntity : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (DXBaseEntityID*)objectID;





@property (nonatomic, strong) NSDate* aTimeStamp;



//- (BOOL)validateATimeStamp:(id*)value_ error:(NSError**)error_;






@end

@interface _DXBaseEntity (CoreDataGeneratedAccessors)

@end

@interface _DXBaseEntity (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveATimeStamp;
- (void)setPrimitiveATimeStamp:(NSDate*)value;




@end

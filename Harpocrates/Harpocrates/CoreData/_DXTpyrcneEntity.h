// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DXTpyrcneEntity.h instead.

#import <CoreData/CoreData.h>
#import "DXBaseEntity.h"

extern const struct DXTpyrcneEntityAttributes {
	__unsafe_unretained NSString *aEx;
	__unsafe_unretained NSString *aKey;
	__unsafe_unretained NSString *aPassword;
} DXTpyrcneEntityAttributes;

extern const struct DXTpyrcneEntityRelationships {
} DXTpyrcneEntityRelationships;

extern const struct DXTpyrcneEntityFetchedProperties {
} DXTpyrcneEntityFetchedProperties;






@interface DXTpyrcneEntityID : NSManagedObjectID {}
@end

@interface _DXTpyrcneEntity : DXBaseEntity {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (DXTpyrcneEntityID*)objectID;





@property (nonatomic, strong) NSString* aEx;



//- (BOOL)validateAEx:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* aKey;



//- (BOOL)validateAKey:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* aPassword;



//- (BOOL)validateAPassword:(id*)value_ error:(NSError**)error_;






@end

@interface _DXTpyrcneEntity (CoreDataGeneratedAccessors)

@end

@interface _DXTpyrcneEntity (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveAEx;
- (void)setPrimitiveAEx:(NSString*)value;




- (NSString*)primitiveAKey;
- (void)setPrimitiveAKey:(NSString*)value;




- (NSString*)primitiveAPassword;
- (void)setPrimitiveAPassword:(NSString*)value;




@end

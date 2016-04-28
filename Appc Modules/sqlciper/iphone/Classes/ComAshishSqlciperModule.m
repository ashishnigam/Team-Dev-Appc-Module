/**
 * sqlciper
 *
 * Created by Your Name
 * Copyright (c) 2015 Your Company. All rights reserved.
 */

#import "ComAshishSqlciperModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import <sqlite3.h>

sqlite3 *db;
@implementation ComAshishSqlciperModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"bcafe7d3-dd69-4046-ae53-a98d8f720e77";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"com.ashish.sqlciper";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];

	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably

	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup

-(void)dealloc
{
	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count
{
	if (count == 1 && [type isEqualToString:@"my_event"])
	{
		// the first (of potentially many) listener is being added
		// for event named 'my_event'
	}
}

-(void)_listenerRemoved:(NSString *)type count:(int)count
{
	if (count == 0 && [type isEqualToString:@"my_event"])
	{
		// the last listener called for event named 'my_event' has
		// been removed, we can optionally clean up any resources
		// since no body is listening at this point for that event
	}
}

#pragma Public APIs

-(id)openDB:(id)databaseName
{
    NSString *result = @"";
    
    @try {
        
        NSString *dbname = [TiUtils stringValue:databaseName[0]];
        
        
        // NSLog(@"[INFO] database name : %@",dbname);
        
        NSMutableString *completeDbName = [[NSMutableString alloc]initWithString:dbname];
        [completeDbName appendString:@".db"];
        
        //NSLog(@"[INFO] completeDbName  %@",completeDbName);
        
        NSString *databasePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
                                  stringByAppendingPathComponent: completeDbName];
        
        // NSLog(@"[INFO] Database file path : %@",databasePath);
        
        
        
        // sqlite3 *db;
        if (sqlite3_open([databasePath UTF8String], &db) == SQLITE_OK) {
            const char* key = [@"Admin!01@Gomobile" UTF8String];
            //sqlite3_key(db, key, strlen(key));
            
            
            // NSLog(@"[INFO] Database successfully opened");
            
            result = @"1";
            
        }
        else{
            
            const char *errMsg = sqlite3_errmsg(db);
            NSString *errMsgStr = [[[NSString alloc] initWithUTF8String:errMsg]autorelease];
            db = NULL;
            
            //NSLog(@"[INFO] Database failed to open");
            
            NSMutableString *completeErrMsg = [[NSMutableString alloc]initWithString:@"Database failed to open,"];
            [completeErrMsg appendString:errMsgStr];
            
            result = completeErrMsg;
            
        }
        
    }
    @catch (NSException *exception) {
        
        NSString *error = [exception reason];
        
        result = error;
        
        //NSLog(@"[ERROR]  exception : %@",[exception reason]);
    }
    
    
    if(db != nil)
    {
        // NSLog(@"[INFO] DB initialized");
    }
    else{
        // NSLog(@"[INFO] DB null");
    }
    
    return result;
    
    
    
}

-(id)closeDB:(id)value
{
    NSString *result =@"0";
    @try {
        
        
        if(db != nil)
        {
            sqlite3_close(db);
            //NSLog(@"[INFO] Database successfully closed ");
            result =@"1";
        }
        else{
            
            const char *errMsg = sqlite3_errmsg(db);
            NSString *errMsgStr = [[[NSString alloc] initWithUTF8String:errMsg]autorelease];
            
            NSMutableString *completeErrMsg = [[NSMutableString alloc]initWithString:@"Database failed to close,"];
            [completeErrMsg appendString:errMsgStr];
            
            result = completeErrMsg;
            
            // NSLog(@"[INFO] Database failed to close , db null");
            
        }
        
    }
    @catch (NSException *exception) {
        
        NSString *error = [exception reason];
        
        result = error;
        
        // NSLog(@"[ERROR]  exception : %@",[exception reason]);
        
    }
    
    return result;
    
}

-(id)createTable:(id)sqlquery
{
    
    NSString *sql = [TiUtils stringValue:sqlquery[0]];
    
    NSString *result=@"";
    
    // NSLog(@"[INFO] create table command :  %@",sql);
    
    
    @try {
        
        if(db != nil)
        {
            char *errMsg;
            const char *sqlcommand = [sql UTF8String];
            
            if(sqlite3_exec(db, sqlcommand, NULL, NULL, &errMsg) == SQLITE_OK)
            {
                // NSLog(@"[INFO] table successfully created : %@",sqlquery);
                
                result = @"1";
            }
            else{
                
                NSString *errMsgStr = [[[NSString alloc] initWithUTF8String:errMsg]autorelease];
                result = errMsgStr;
                
                // NSLog(@"[INFO] table failed to create : %@",sqlquery);
                
            }
        }
        else{
            
            // NSLog(@"[INFO] database null, failed to create table : %@",sqlquery);
            result = @"Database not initialized.";
        }
    }
    @catch (NSException *exception) {
        
        NSString *error = [exception reason];
        
        result = error;
        // NSLog(@"[ERROR]  exception : %@",[exception reason]);
    }
    
    
    
    
    return result;
    
}

-(id)dropTable:(id)args
{
    NSString *result=@"0";
    
    NSString *tableName = [TiUtils stringValue:args[0]];
    
    //NSLog(@"[INFO] You are going to drop table : %@",tableName);
    
    
    @try {
        
        if(db != nil)
        {
            char *errMsg;
            
            NSMutableString *sql = [[NSMutableString alloc]initWithString:@"DROP Table "];
            [sql appendString:tableName];
            
            const char *sqlcommand = [sql UTF8String];
            
            if(sqlite3_exec(db, sqlcommand, NULL, NULL, &errMsg) == SQLITE_OK)
            {
                // NSLog(@"[INFO] table successfully dropped : %@",sql);
                
                result = @"1";
            }
            else{
                NSString *errMsgStr = [[[NSString alloc] initWithUTF8String:errMsg]autorelease];
                result = errMsgStr;
                
                //NSLog(@"[INFO] table failed to drop : %@",sql);
                
            }
        }
        else{
            //NSLog(@"[INFO] database null, failed to drop table : %@",tableName);
            result = @"Database not initialized.";
        }
        
    }
    @catch (NSException *exception) {
        NSString *error = [exception reason];
        
        result = error;
        // NSLog(@"[ERROR]  exception : %@",[exception reason]);
    }
    
    
    return result;
    
    
    
    
}

-(id)executeDML:(id)sqlquery
{
    NSString *result=@"0";
    
    NSString *sql = [TiUtils stringValue:sqlquery[0]];
    
    
    // NSLog(@"[INFO] DML query: %@",sql);
    
    @try {
        
        if(db != nil)
        {
            sqlite3_stmt *statement;
            
            const char *sqlcommand = [sql UTF8String];
            
            sqlite3_prepare_v2(db, sqlcommand,-1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                //NSLog(@"[INFO] DML query successfully executed : %@",sql);
                result = @"1";
            }
            else{
                
                
                const char *errMsg = sqlite3_errmsg(db);
                NSString *errMsgStr = [[[NSString alloc] initWithUTF8String:errMsg]autorelease];
                
                result = errMsgStr;
                
                //NSLog(@"[INFO] DML query failed to execute : %@",sql);
                
                
            }
            sqlite3_finalize(statement);
            
        }
        else{
            //NSLog(@"[INFO] database null, failed to execute DML query : %@",sql);
            result = @"Database not initialized.";
        }
    }
    @catch (NSException *exception) {
        NSString *error = [exception reason];
        
        result = error;
        //NSLog(@"[ERROR]  exception : %@",[exception reason]);
    }
    
    
    return result;
    
    
}


-(id)executeReader:(NSArray *)ary
{
    
    int aryLen = [ary[0] count];
    
    
    
    NSMutableString *jsonResult = [[NSMutableString alloc]initWithString:@"["];
    
    NSString *errMsg = @"";
    
    NSString *successFlag=@"0";
    
    
    @try {
        
        
        
        if(db != NULL)
        {
            sqlite3_stmt *statement;
            
            NSString *sql = ary[0][0];
            //  NSLog(@"[INFO] Reader query : %@",sql);
            
            const char *sqlcommand = [sql UTF8String];
            int result=0;
            
            if (sqlite3_prepare_v2(db,sqlcommand, -1, &statement, NULL)== SQLITE_OK)
            {
                int dataExist=0;
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    
                    
                    NSMutableString *rowData = [[NSMutableString alloc]initWithString:@"{"];
                    
                    
                    for(int i=1;i<aryLen;i++)
                    {
                        char *columnValue = (char *) sqlite3_column_text(statement,i-1);
                        NSString *value = [[[NSString alloc] initWithUTF8String:columnValue]autorelease];
                        
                        // NSLog(@"[INFO] Reader query value : %@",value);
                        
                        NSString *key = ary[0][i];
                        
                        
                        NSMutableString *columnData = [[NSMutableString alloc]initWithString:@"\""];
                        [columnData appendString:key];
                        [columnData appendString:@"\":\""];
                        [columnData appendString:value];
                        [columnData appendString:@"\""];
                        
                        
                        
                        [rowData appendString:columnData];
                        
                        if(i != aryLen-1)
                        {
                            [rowData appendString:@","];
                        }
                        
                        
                        // NSLog(@"[INFO] column data : %@",columnData);
                        
                    }
                    
                    [rowData appendString:@"}"];
                    
                    [jsonResult appendString:rowData];
                    
                    
                    [jsonResult appendString:@","];
                    
                    
                    // NSLog(@"[INFO] Row data : %@",rowData);
                    
                    dataExist =1;
                    
                }
                sqlite3_finalize(statement);
                
                
                if(dataExist == 1)
                {
                    [jsonResult deleteCharactersInRange:NSMakeRange([jsonResult length]-1, 1)];
                }
                
                
                //  NSLog(@"[INFO] Reader query successfully executed : %@",jsonResult);
                successFlag =@"1";
            }
            else{
                
                const char *err = sqlite3_errmsg(db);
                errMsg = [[[NSString alloc] initWithUTF8String:err]autorelease];
                successFlag =@"0";
                // NSLog(@"[INFO] Reader query failed to execute : %@",sql);
                
            }
            
            
        }
        else{
            
            errMsg = @"Database not initialized.";;
            successFlag =@"0";
            //  NSLog(@"[INFO] database null, failed to execute Reader query : %@");
        }
        
        
    }
    @catch (NSException *exception) {
        
        NSString *error = [exception reason];
        errMsg = error;
        successFlag =@"0";
        // NSLog(@"[ERROR]  exception : %@",[exception reason]);
    }
    
    
    [jsonResult appendString:@"]"];
    
    
    NSMutableString *resultData=[[NSMutableString alloc]initWithString:@"{\"header\":{\"status\":\""];
    [resultData appendString:successFlag];
    [resultData appendString:@"\",\"errormsg\":\""];
    [resultData appendString:errMsg];
    [resultData appendString:@"\"},\"result\":"];
    [resultData appendString:jsonResult];
    [resultData appendString:@"}"];
    
    
    return resultData;
    
}



-(id)executeDMLP:(NSArray *)ary
{
    
    int aryLen = [ary[0] count];
    
    NSString *result=@"0";
    
    NSString *sql = ary[0][0];
    
    
    // NSLog(@"[INFO] DML query: %@",sql);
    
    @try {
        
        if(db != nil)
        {
            sqlite3_stmt *statement;
            
            const char *sqlcommand = [sql UTF8String];
            
            sqlite3_prepare_v2(db, sqlcommand,-1, &statement, NULL);
            
            int i=1;
            for(i=1;i<aryLen;i++)
            {
                NSString *parameterStr = ary[0][i];
                const char *parameter = [parameterStr UTF8String];
                sqlite3_bind_text(statement, i, parameter, -1, SQLITE_TRANSIENT);
                
            }
            
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                //NSLog(@"[INFO] DML query successfully executed : %@",sql);
                result = @"1";
            }
            else{
                
                
                const char *errMsg = sqlite3_errmsg(db);
                NSString *errMsgStr = [[[NSString alloc] initWithUTF8String:errMsg]autorelease];
                
                result = errMsgStr;
                
                //  NSLog(@"[INFO] DML query failed to execute : %@",sql);
                
                
            }
            sqlite3_finalize(statement);
            
        }
        else{
            // NSLog(@"[INFO] database null, failed to execute DML query : %@",sql);
            result = @"Database not initialized.";
        }
    }
    @catch (NSException *exception) {
        NSString *error = [exception reason];
        
        result = error;
        // NSLog(@"[ERROR]  exception : %@",[exception reason]);
    }
    
    
    return result;
    
    
}







-(id)executeReaderP:(NSArray *)array
{
    
    
    NSArray *ary =[[NSArray alloc]initWithArray:array[0]];
    
    NSArray *parameters = nil;
    if(ary.count >1)
    {
        parameters = [[NSArray alloc]initWithArray:ary[1]];
    }
    
    
    
    int aryLen = [ary[0] count];
    
    
    
    NSMutableString *jsonResult = [[NSMutableString alloc]initWithString:@"["];
    
    NSString *errMsg = @"";
    
    NSString *successFlag=@"0";
    
    
    @try {
        
        
        
        if(db != NULL)
        {
            sqlite3_stmt *statement;
            
            NSString *sql = ary[0][0];
            
            
            //NSLog(@"[INFO] Reader query : %@",sql);
            
            const char *sqlcommand = [sql UTF8String];
            int result=0;
            
            if (sqlite3_prepare_v2(db,sqlcommand, -1, &statement, NULL)== SQLITE_OK)
            {
                
                //  NSLog(@"[INFO] parameter are : %d",[parameters count]);
                for(int k=0;k<parameters.count;k++)
                {
                    NSString *parameterStr = parameters[k];
                    //NSLog(@"[INFO] parameter are : %@",parameterStr);
                    
                    
                    const char *parameter = [parameterStr UTF8String];
                    sqlite3_bind_text(statement, k+1, parameter, -1, SQLITE_TRANSIENT);
                }
                
                
                int dataExist=0;
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    
                    
                    NSMutableString *rowData = [[NSMutableString alloc]initWithString:@"{"];
                    
                    
                    for(int i=1;i<aryLen;i++)
                    {
                        char *columnValue = (char *) sqlite3_column_text(statement,i-1);
                        NSString *value = [[[NSString alloc] initWithUTF8String:columnValue]autorelease];
                        
                        // NSLog(@"[INFO] Reader query value : %@",value);
                        
                        NSString *key = ary[0][i];
                        
                        
                        NSMutableString *columnData = [[NSMutableString alloc]initWithString:@"\""];
                        [columnData appendString:key];
                        [columnData appendString:@"\":\""];
                        [columnData appendString:value];
                        [columnData appendString:@"\""];
                        
                        
                        
                        [rowData appendString:columnData];
                        
                        if(i != aryLen-1)
                        {
                            [rowData appendString:@","];
                        }
                        
                        
                        //  NSLog(@"[INFO] column data : %@",columnData);
                        
                    }
                    
                    [rowData appendString:@"}"];
                    
                    [jsonResult appendString:rowData];
                    
                    
                    [jsonResult appendString:@","];
                    
                    
                    // NSLog(@"[INFO] Row data : %@",rowData);
                    
                    dataExist =1;
                    
                }
                sqlite3_finalize(statement);
                
                
                if(dataExist == 1)
                {
                    [jsonResult deleteCharactersInRange:NSMakeRange([jsonResult length]-1, 1)];
                }
                
                
                // NSLog(@"[INFO] Reader query successfully executed : %@",jsonResult);
                successFlag =@"1";
            }
            else{
                
                const char *err = sqlite3_errmsg(db);
                errMsg = [[[NSString alloc] initWithUTF8String:err]autorelease];
                successFlag =@"0";
                // NSLog(@"[INFO] Reader query failed to execute : %@",sql);
                
            }
            
            
        }
        else{
            
            errMsg = @"Database not initialized.";;
            successFlag =@"0";
            // NSLog(@"[INFO] database null, failed to execute Reader query : %@");
        }
        
        
    }
    @catch (NSException *exception) {
        
        NSString *error = [exception reason];
        errMsg = error;
        successFlag =@"0";
        // NSLog(@"[ERROR]  exception : %@",[exception reason]);
    }
    
    
    [jsonResult appendString:@"]"];
    
    
    NSMutableString *resultData=[[NSMutableString alloc]initWithString:@"{\"header\":{\"status\":\""];
    [resultData appendString:successFlag];
    [resultData appendString:@"\",\"errormsg\":\""];
    [resultData appendString:errMsg];
    [resultData appendString:@"\"},\"result\":"];
    [resultData appendString:jsonResult];
    [resultData appendString:@"}"];
    
    
    return resultData;
    
}


@end

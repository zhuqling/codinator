/*
 Copyright (c) 2015, Vladimir Danila
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.

 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL PIERRE-OLIVIER LATOUR BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

@import Foundation;
@import WebKit;


#import "Thumbnail.h"
#import "UIColor+HexString.h"
#import "NSUserDefaults+Additions.h"


@interface Polaris : NSObject <WKNavigationDelegate>



/**
 * @brief The initializer for creating a new project.
 * @discussion This initializer is for creating a new project and setting up the required files in the related location.
 * @param path Path of the location where a project will be created.
 * @param name Desired name of the project
 * @param extension Extension of the project.
 * @warning Do not use this for initializing a project!
 * @code
 * Polaris *projectManager = [[Polaris alloc] initWithProjectCreatorAtPath:pathWhereProjWillBeCreated withName:projName andExtension:projExtension];
 * @endcode
 * @since 1.0
 */
- (instancetype)initWithProjectCreatorAtPath:(NSString *)path withName:(NSString *)name andExtension:(NSString *)extension;

/**
 * @brief The initializer for creating the required project files.
 * @discussion This initializer is for creating all required project files at an already existing location.
 * @param path Path of the directory where all reqired files will be injected.
 * @warning Do not use this for initializing a project or when initWithProjectCreatorAtPath: could be used!
 * @code
 * Polaris *projectManager = [[Polaris alloc] createProjectRequiredFilesAtPath:(NSString *)path];
 * @endcode
 * @since 1.1
 */
- (instancetype)initWithCreatingProjectRequiredFilesAtPath:(NSString *)path;



- (instancetype)initWithProjectPath:(NSString *)path andWithWebServer:(BOOL)useWebServer UploadServer:(BOOL)useUploadServer andWebDavServer:(BOOL)useWebDavServer __deprecated_msg("use initWithProjectPath: currentView: instead.");



/**
 * @brief The default initializer.
 * @discussion This is the default initializer.
 * @param path The path of the project with that you want to initialize Polaris
 * @param useWebServer If YES a web server will be started
 * @param useUploadServer If YES a web upload server will be started, that makes it easy to transfer files between any device in the same network.
 * @param useWebDavServer If YES a web dav server will be started.
 * @warning Do not use this if you want to create a project!
 * @code
 * Polaris *projectManager = [[Polaris alloc] initWithProjectPath:path andWithWebServer:true UploadServer:true andWebDavServer:true];
 * @endcode
 * @since 1.4
 */
- (instancetype)initWithProjectPath:(NSString *)path currentView:(UIView *)view WithWebServer:(BOOL)useWebServer UploadServer:(BOOL)useUploadServer andWebDavServer:(BOOL)useWebDavServer;



/**
 * @brief Call this when a project is closed.
 * @discussion This method stops all background tasks.
 * @warning Do not use this if you used initWithProjectCreatorAtPath or initialized without a server!
 * @code
 * [projectManager close];
 * @endcode
 * @since 1.0
 */
- (void)close;

#pragma mark - hold variables

/**
 * @brief The currently selected file.
 * @discussion This specifies a variable that is used for saving selected/used file paths temporary Use it for memoring a user selected file path or for the cellForRow finction.
 * @code
 * projectManager.selectedFilePath = path;
 * @endcode
 * @since 0.8
 */
@property (nonatomic, strong) NSString *selectedFilePath;

/**
 * @brief The path of the file browser.
 * @discussion This specifies a variable that is used for memorizing the path that is currently displayed in the file browser.
 * @warning Do not assign a path of a specific path to this variable. Use the selectedFilePath variable instead then.
 * @code
 * projectManager.inspectorPath = dirPath;
 * @endcode
 * @since 0.9
 */
@property (nonatomic, strong) NSString *inspectorPath;

/**
 * @brief The path of a file that might be deleted.
 * @discussion This specifies a variable that is used for memorizing a file path for a file that might be deleted or that was associated within a delete context.
 * @warning Do not assign a path of a file path that was never associated with a delete context. Use the selectedFilePath variable instead then.
 * @code
 * projectManager.deletePath = FileAssociatedWithDelete;
 * @endcode
 * @since 0.9
 */
@property (nonatomic, strong) NSString *deletePath;

/**
 * @brief The path of an Archive.
 * @discussion This specifies a variable that is used for memorizing an Archive path.
 * @code
 * projectManager.archivePath = AssociatedArchive;
 * @endcode
 * @since 1.0
 */
@property (nonatomic, strong) NSString *archivePath;


/**
 * This specifies a variable that is used for memorizing a path temporary.
 */
@property (nonatomic, strong) NSString *tmpFilePath;


#pragma mark - functions


- (void)generateATVPreview;


/**
 * @brief Path Removes everything before the Assets folder from the path of the selected file
 * @discussion This method returns a filtered path for the selectedFile.
 * @warning selectedFilePath has to have a file path associated.
 * @code
 * NSString *filePath = [projectManager fakePathForSelectedFile];
 * @endcode
 * @return The path of the selected file with everything before the Asstes folder filtered out
 * @since 1.0
 */
- (NSString *)fakePathForFileSelectedFile;

/**
 * @brief Path with everything removed before the Assets folder 
 * @discussion This method returns a filtered path for any file within the project.
 * @param The path of the file you want to fake the path to.
 * @code
 * NSString *filePath = [projectManager fakePathForFile:currentFile];
 * @endcode
 * @return Path with everything before the Asstes folder filtered out
 * @since 1.0
 */
- (NSString *)fakePathForFile:(NSString *)selectedFile;

/**
 * @brief Array of the files in the current directory
 * @discussion This method can be used for a file browser or everything else when all files are needed in an array from the currently used directory.
 * @code
 * NSMutableArray *items = [projectManager contentsOfCurrentDirectory];
 * @endcode
 * @return An mutable array of NSString objects, each of which identifies a file, directory, or symbolic link contained in path. Returns an empty array if the directory exists but has no contents. If an error occurs, this method returns nil and assigns an appropriate error object to the error parameter
 * @since 1.0
 */
- (NSMutableArray *)contentsOfCurrentDirectory;

/**
 * @brief Array of the files in the current directory
 * @discussion This method can be used for a file browser or everything else when all files are needed in an array from the currently used directory.
 * @param path The path to the directory whose contents you want to enumerate.
 * @code
 * NSMutableArray *items = [projectManager contentsOfCurrentDirectory];
 * @endcode
 * @return An mutable array of NSString objects, each of which identifies a file, directory, or symbolic link contained in path. Returns an empty array if the directory exists but has no contents. If an error occurs, this method returns nil and assigns an appropriate error object to the error parameter
 * @sice 1.0
 */
- (NSMutableArray *)contentsOfDirectoryAtPath:(NSString *)path;

/**
 * @brief Saves the current project state
 * @discussion This method saves the entire user directory and adds a note to it. Afterwards they can be restored or used as another branch. That's up to you.
 * @param message A note that can be saved with the new archive.
 * @code
 * [projectManager archiveWorkingCopyWithCommitMessage:@"Version 1.0, I changed ...."];
 * @endcode
 * @sice 1.0
 */
- (void)archiveWorkingCopyWithCommitMessge:(NSString *)message;


/**
 * @brief Deletes the backup in the version dictionary
 * @discussion This method deletes the automaticly taken backup every 10 min
 * @since 1.2
 */
- (void)deleteBackup;

/**
 * Returns YES if a backup exists.
 */
- (BOOL)checkIfBackupExists;

/**
 * Set this to YES to pause creating a backup every 10 minuets.
 */
@property BOOL pauseAutobackup;


#pragma mark - server

/**
 * @brief The URL for the web server
 * @discussion This method returns the IP of your current device on that the server is running and the related port (8080)
 * @code
 * NSString *webServerUrl = [projectManager webServerURL];
 * @endcode
 * @return Returns the IP + Port
 * @since 1.0
 */
- (NSString *)webServerURL;

/**
 * @brief The URL for the web uploading server
 * @discussion This method returns the IP of your current device on that the server is running and the related port (80)
 * @code
 * NSString *webUploaderUrl = [projectManager webUploaderServerURL];
 * @endcode
 * @return Returns the IP + Port
 * @since 1.0
 */
- (NSString *)webUploaderServerURL;

/**
 * @brief The URL for the webDav server
 * @discussion This method returns the IP of your current device on that the server is running and the related port (443)
 * @code
 * NSString *webUploaderUrl = [projectManager webDavServerURL];
 * @endcode
 * @return Returns the IP + Port
 * @since 1.0
 */
- (NSString *)webDavServerURL;


#pragma mark - Paths

/**
 * @brief The project path
 * @discussion This method returns the path of the initialized project.
 * @code
 * NSString *path = [projectManager projectPath];
 * @endcode
 * @return Returns the project path
 * @since 0.4
 */
-(NSString *)projectPath;

/**
 * @brief The project documents path
 * @discussion This method returns the path of the directory where the user can save files
 * @warning Do not use this path so save settings or versioning related things.
 * @code
 * NSString *path = [projectManager projectUserDirectoryPath];
 * @endcode
 * @return Returns the project user directory path
 * @since 0.4
 */
- (NSString *)projectUserDirectoryPath;

/**
 * @brief The project versioning path
 * @discussion This method returns the path of the versioning directory.
 * @warning Do not use this path so save settings or user documents related things.
 * @code
 * NSString *path = [projectManager projectVersionsPath];
 * @endcode
 * @return Returns the project user directory path
 * @since 0.4
 */
- (NSString *)projectVersionsPath;


/**
 * @brief The project temp path
 * @discussion This method returns the path of the projects temp directory.
 * @warning Do not use this path so save user oriented things.
 * @code
 * NSString *path = [projectManager projectTempPath];
 * @endcode
 * @return Returns the projects temp directory path
 * @since 1.1
 */
- (NSString *)projectTempPath;


/**
 * @brief The project settings path
 * @discussion This method returns the path of the settings directory.
 * @warning Do not use this path so save settings or user documents related things.
 * @code
 * NSString *path = [projectManager projectVersionsPath];
 * @endcode
 * @return Returns the project user directory path
 * @since 0.4
 */
- (NSString *)projectSettingsPath;


/**
 * @brief The project Apple TV 4+ Preview file(s)
 * @discussion This method returns the path of the Apple TV 4+ data directory.
 * @warning Do not use this path so save settings or user documents related things nor other kind of files than PNGs.
 * @code
 * NSString *path = [projectManager appleTVPreviewPath];
 * @endcode
 * @return Returns the Apple TV 4+ directory path
 * @since 1.4
 */
- (NSString *)appleTVPreviewPath;

#pragma mark - Values
/**
 * @brief The project current version
 * @discussion This method returns the version of the project.
 * @warning A value for the key 'Version' has to be saved.
 * @code
 * NSString *version = [projectManager projectCurrentVersion];
 * @endcode
 * @return Returns the projects current version.
 * @since 0.4
 */
- (NSString *)projectCurrentVersion;

/**
 * @brief The project copyright holder version
 * @discussion This method returns the copyright holder of the project.
 * @warning A value for the key 'Copyright' has to be saved.
 * @code
 * NSString *version = [projectManager projectCopyright];
 * @endcode
 * @return Returns the projects copyright holder.
 * @since 0.5
 */
- (NSString *)projectCopyright;

/**
 * @brief The project version
 * @discussion This method returns the gistID of the project.
 * @warning A value for the key 'gistID' has to be saved.
 * @code
 * NSString *version = [projectManager projectGistID];
 * @endcode
 * @return Returns the projects gistID.
 * @since 0.5
 */
- (NSString *)projectGistID;

#pragma mark - Settings

/**
 * @brief Saves a GistID
 * @discussion This method saves a GistID.
 * @param gistID The GistID that has to be saved.
 * @code
 * [projectManager updateGistID:@"5325"];
 * @endcode
 * @sice 1.0
 */
- (void)updateGistID:(NSString*)gistID;

/**
 * @brief Updates the version number
 * @discussion This method updates/saves the version number for the key: 'version'.
 * @param versionNumber The version number that should be saved.
 * @code
 * [projectManager updateVersionNumberToVersion:2"];
 * @endcode
 * @sice 0.8
 */
- (void)updateVersionNumberToVersion:(int)versionNumber;

/**
 * @brief Updates a value for a key.
 * @discussion This method updates a value for a key.
 * @warning Do not use this for saving a NEW value. Use the saveValueForKey method instead.
 * @param key The key to that the variable will be associated.
 * @param anObject The object you want to save.
 * @code
 * [projectManager updateSettingsValueForKey:@"GitHubPassword" withValue:EncryptedString];
 * @endcode
 * @sice 0.8
 */
- (void)updateSettingsValueForKey:(NSString *)key withValue:(id)anObject;

/**
 * @brief Saves a value for a new key.
 * @discussion This method saves a value for a new key.
 * @warning Do not use this for updating an old object. Use the updateSettingsValueForKeyWithValue method instead.
 * @param key The new key to that the variable will be associated.
 * @param anObject The object you want to save.
 * @code
 * [projectManager updateSettingsValueForKey:@"GitHubPassword" withValue:EncryptedString];
 * @endcode
 * @sice 0.8
 */
- (void)saveValue:(NSString *)value forKey:(NSString *)key;

/**
 * @brief Returns a saved value.
 * @discussion This method returns a saved value associated to a key.
 * @param key The new key to that the variable is associated.
 * @code
 * NSString *string = [projectManager getSettingsDataForKey:@"GitHubPassword"];
 * @endcode
 * @return An saved object associated to the specific key
 * @sice 0.9
 */
- (id)getSettingsDataForKey:(NSString *)key;


@end
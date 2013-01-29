
====================

ios-demo description

====================

/**************************************************
 *  How to use "support"
 *  1. add support directory (contain directory: CustomView,Utility,Base64,JSON and file: CommDefines.h)
 *  2. add frameworks: AVFoundation.framework, QuartzCore.framework, MediaPlayer.framework
 *  3. add lib: libxml2.dylib
 *  4. add head search path: /usr/include/libxml2/
 *
 *  How to use "ASIHttpRequest"
 *  1. add ASIHttpRequest directory (contain Reachability directory)
 *  2. add frameworks: CFNetwork.framework, SystemConfiguration.framework, MobileCoreServices.framework
 *  3. add lib: libz.dylib
 *
 *  How to use "Kal"
 *  1. add Kal.xcodeproj and Kal.bundle
 *  2. add Target Dependencies(Project/Build Phases/Target Dependencies)
 *  3. drag libKal.a to Link Binary with Libraries
 *  4. if Kal.bundle does not in Copy Bundle Resources, drag into it
 *  5. add "-all_load" to Project/Target/Build Settings/Linking/Other Linker Flags

    ==================================================

 *  About iCarousel:
 *  iCarousel doesn't support Xcode 4.2 or Snow Leopard any more. 
 *  The minimum supported version is 4.3 on Lion.
 *  If you want to run it on 4.2 (bearing in mind that Apple no longer accept apps to the app store that are built with 4.2) 
 *  you can download an older version from this page:
 *  https://github.com/nicklockwood/iCarousel/tags
 *
 *  I believe version 1.6.1 and earlier worked on 4.2, 
 *  but if you still get errors with it, just keep downloading an earlier version until you find one that works.
 *
 *  EDIT: To be clear, apps built using iCarousel do still support Snow Leopard, but you cannot develop using Snow Leopard.

    ==================================================

 *  How to add font to project:
 *  1. in info.plist add "Fonts provided by application" key;
 *  2. add font name to "Fonts provided by application" items;
 */


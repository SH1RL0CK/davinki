'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "favicon.png": "5dcef449791fa27946b3d35ad8803796",
"index.html": "b4dd94e1ecbdfa5028cd029a7c1f1d9b",
"/": "b4dd94e1ecbdfa5028cd029a7c1f1d9b",
"assets/NOTICES": "6f0fcb196d329959f659cbd5d4672341",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "4e6447691c9509f7acdbf8a931a85ca1",
"assets/AssetManifest.json": "2efbb41d7877d10aac9d091f58ccd7b9",
"splash/img/light-3x.png": "ebe3c68938e322b2b7875fd9bb94cd7a",
"splash/img/light-4x.png": "d22a53be0339c3cc68a37928bfa3c9ba",
"splash/img/light-2x.png": "e0800d442c9227d360244b5bd128d090",
"splash/img/dark-3x.png": "ebe3c68938e322b2b7875fd9bb94cd7a",
"splash/img/dark-2x.png": "e0800d442c9227d360244b5bd128d090",
"splash/img/light-1x.png": "9d1154ef82d21841a7ee9feeab527936",
"splash/img/dark-1x.png": "9d1154ef82d21841a7ee9feeab527936",
"splash/img/dark-4x.png": "d22a53be0339c3cc68a37928bfa3c9ba",
"splash/style.css": "bbf0bdd2640bb72d3b51d44784456608",
"version.json": "d1fa66c76fa585275abd054d446a7116",
"manifest.json": "b58fcfa7628c9205cb11a1b2c3e8f99a",
"favicon.ico": "5a1e827ddbb5f2cd95f7ad59df2bce53",
"icons/favicon-16x16.png": "dc5fbd67a79226ddfbc7dabedf3eada4",
"icons/apple-icon-76x76.png": "c05a0bb5fb7fae89c0b15935d24940de",
"icons/android-icon-36x36.png": "7d7d446e62a592f7bcde09cc9610b681",
"icons/apple-icon-114x114.png": "b702f45a630424d2bc9fe93f4832a99e",
"icons/apple-icon-144x144.png": "87340ecb1a9349c4e0b4dae37054a005",
"icons/apple-icon-57x57.png": "86eafff3561e0787284004c9bbb0376f",
"icons/android-icon-192x192.png": "d7216079af618f8dda13bb4fb58baa05",
"icons/apple-icon.png": "db53fed1f6318432c2c21a83327b7bf3",
"icons/apple-icon-precomposed.png": "db53fed1f6318432c2c21a83327b7bf3",
"icons/android-icon-144x144.png": "87340ecb1a9349c4e0b4dae37054a005",
"icons/android-icon-72x72.png": "e2abf0eea895fbf0af200086f6f8ffe4",
"icons/ms-icon-70x70.png": "ffd8dafea37a12645e964a680d35df6c",
"icons/favicon.ico": "c7dcd4f898b9e4b63d43c9340360b679",
"icons/android-icon-48x48.png": "c801819219265c5bdc8c25e39efdee32",
"icons/favicon-32x32.png": "b602ab8c8fbb760b6771b1408e25f1db",
"icons/apple-icon-60x60.png": "ca5d78cdd25f6ab5604784beb2dba64f",
"icons/apple-icon-152x152.png": "3ba53d6b4d8ea6d5b74372ed77029dd8",
"icons/android-icon-96x96.png": "fa16d7e4cf66a1892ba6bec4a1986b44",
"icons/ms-icon-144x144.png": "87340ecb1a9349c4e0b4dae37054a005",
"icons/ms-icon-310x310.png": "8ef439c3940bb22ebfe188092b61aac1",
"icons/favicon-96x96.png": "b1b225341e5d023c8e252ff4d0a9bf9b",
"icons/apple-icon-72x72.png": "e2abf0eea895fbf0af200086f6f8ffe4",
"icons/ms-icon-150x150.png": "51f9235c454f90b34108d2d764154f69",
"icons/apple-icon-180x180.png": "08dd4ee2d6acec0cdf7c68b4f4531dd4",
"icons/apple-icon-120x120.png": "ef94a1f514c1a72f13f9fbdf6d4b32fb",
"main.dart.js": "4d8037e20770ee9edeafccfefffea1d4",
"browserconfig.xml": "80016bcba5707e506c8278ca49483585"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/NOTICES",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}

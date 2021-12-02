'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "version.json": "4df985213de6e5d0d05e7b46341eec92",
"manifest.json": "10199eb64991ec3530799fc727d71ba8",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"main.dart.js": "886825bf084943ff85e51f650ff521c9",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"index.html": "113f429f22c46f60c6bc4c44f8a5814d",
"/": "113f429f22c46f60c6bc4c44f8a5814d",
"assets/FontManifest.json": "6c551a1c1929bb67a2c2f9e4fd9a9234",
"assets/AssetManifest.json": "517a6e102e79112d880030e8f0120789",
"assets/assets/audio/intro.mp3": "7f6a3dd073d25abad54ae3b8e16fe209",
"assets/assets/audio/sci-fi.mp3": "ed7c8f88873d5a67e254444a46fa7086",
"assets/assets/audio/battle.mp3": "1982640e39cd14b1ec7a92378254fadd",
"assets/assets/fonts/FrederickatheGreat-Regular.ttf": "9122299e476671f970e1670bd7b900c8",
"assets/assets/fonts/SigmarOne-Regular.ttf": "802f1339c20a1cf1aabf8f48d832d128",
"assets/assets/fonts/PressStart2P-Regular.ttf": "2c404fd06cd67770807d242b2d2e5a16",
"assets/assets/sprites/heeves/worker.fa": "fb015e000c55606522a9db731e909c94",
"assets/assets/sprites/heeves/worker-idle.fa": "8f68d58b7727d995b8436beb261e26b9",
"assets/assets/sprites/nivurium-ore-idle.fa": "7bbe38c43f6b29db668acf0eea8c5203",
"assets/assets/sprites/humans/infantry-idle.fa": "502dcce6e46a00560d1cda4ef2f65e99",
"assets/assets/sprites/humans/infantry-attack.fa": "3209f41680add4673fdaf146e94efd65",
"assets/assets/sprites/humans/infantry-die.fa": "ecbc3765cc59b65426ec602e474c24ee",
"assets/assets/sprites/humans/infantry.fa": "0a88bac783e9e7d296cf085162666aa9",
"assets/assets/sprites/nivurium-ore-die.fa": "c201faee8fbe7a830c730e5113020403",
"assets/assets/images/flame.png": "f910f712d3a1faa6e001faae377aa72e",
"assets/assets/images/butterfly.png": "51f726d939901f4f4bc804525de74d4c",
"assets/assets/images/tileset.png": "c958a8ba1b23cb7b922f2715036256c2",
"assets/assets/images/human-spaceship.png": "4c01c216528f83fa04a3908680c365ce",
"assets/assets/images/hatchery.png": "29165623bcfcfc81db826cfd76db237b",
"assets/assets/images/red_buttons.png": "d48606e5ca72c4b9c1f176e40ec9c30b",
"assets/assets/images/green_buttons.png": "88f66442349bebb2d636342c1107294a",
"assets/assets/images/nine-box.png": "0d2659458b8177f012641173f06aaaba",
"assets/NOTICES": "eb13c9aa804779ce93ee9765e8806029"
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

'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/chromium/canvaskit.js": "34beda9f39eb7d992d46125ca868dc61",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/canvaskit.js": "86e461cf471c1640fd2b461ece4589df",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"manifest.json": "f18b45698fa17771b8e714c901101b89",
"main.dart.js": "8a2f44c604c363ecedc9a8b1dc403b04",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"index.html": "cae0d51f36eea9033ec8afb7de5b14f9",
"/": "cae0d51f36eea9033ec8afb7de5b14f9",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6fe173ea12f3b4da4a93f9be090dfb68",
"assets/AssetManifest.bin.json": "a836419867c51605418587869797c7e3",
"assets/AssetManifest.bin": "bdf3c543c7d2fa7165fb9a3ff3e483e4",
"assets/NOTICES": "4908824a9b237732738ef90207d4cc09",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/assets/animations/error.json": "f1e0f3e09f7acd9a9dae10987ca1c06a",
"assets/assets/animations/create.json": "3ed62ec4c6751bafb2e0c52cec8421f4",
"assets/assets/animations/user.json": "05f3ba8e3f449edc913ba0667b8e1ede",
"assets/assets/animations/error1.json": "175f2437624d6f554344c4970ca524ae",
"assets/assets/animations/delete.json": "2d7d05a9e8ce2365ce6812a075baeef3",
"assets/assets/animations/timeout.json": "e18bfedfe178d8aaa5dc048459fb35ff",
"assets/assets/animations/form.json": "64471656c1dc900a5d497339aaa4ce11",
"assets/assets/animations/create1.json": "e835bfef109711ec70bccbfcfbca025c",
"assets/assets/animations/edit2.json": "f8d9f6ebadebebf336ebf1b6b9816da5",
"assets/assets/animations/edit1.json": "fe10d8d9316d31762f566569accdc657",
"assets/assets/animations/oops.json": "5c9b86f61fe25d4d3053bf8e731fafac",
"assets/assets/animations/success.json": "1ef882e12955fcd50e5a1e52b4680f1e",
"assets/assets/animations/edit.json": "2a4f061237bf9efcbf3cd8c694994e7a",
"assets/assets/icons/view.svg": "c1b10ebdb1751f96a7d72d6f0c5a0009",
"assets/assets/icons/dash.svg": "078de85c7de5e6d2b80c435f287a5e3a",
"assets/assets/icons/ocpi.png": "60c9e4ce86413b42c0f271a8bc6c2312",
"assets/assets/icons/chsession.svg": "563b8f6b74d08d00dee6aba84f199aab",
"assets/assets/icons/delete.svg": "69337bee96e148526e400b2a411e69ba",
"assets/assets/icons/download.svg": "4a1a3608e6afb1352f9ab4c1062a1780",
"assets/assets/icons/dashboard1.svg": "c1dfbe7606ee4a2a9a5e858d800a9785",
"assets/assets/icons/power1.svg": "cd59ab32c6d0fab9ab20e98f6fd55868",
"assets/assets/icons/logout.svg": "5e0a770194c624e1e5763077e0df3576",
"assets/assets/icons/ev_leaf.svg": "8df5d1e4da2037ffaf3793326cc7d292",
"assets/assets/icons/menu.svg": "54acde9f316c9a337f6be624bc836002",
"assets/assets/icons/leaf4.svg": "6fde4064114ab82b651b86ab609f0f0a",
"assets/assets/icons/settings.svg": "b3391210f87e917f0c3b64150985ca8f",
"assets/assets/icons/dashboard.svg": "f74fa54003f05afe63813ffa6559abd9",
"assets/assets/icons/sms.png": "63c114b519bdd15aa14d6e912a4e8578",
"assets/assets/icons/mail.png": "bcb7da3b0772db5b4294eeeb8b6c0553",
"assets/assets/icons/users.svg": "71d8759b29cc9f514f262db8ab09a09f",
"assets/assets/icons/org.svg": "f5c8a354fb62aa9c4cd8e21a7e52d864",
"assets/assets/icons/leaf9.svg": "11eb081df89edd1d8f80a4bbc4a658ff",
"assets/assets/icons/upload.svg": "8fffb787ed532cf6e572f1a39df39bab",
"assets/assets/icons/leaf2.svg": "a5cb6e637fd428ffa154e06cead6a64d",
"assets/assets/icons/rupee.svg": "a94682df841eb4ec2fdbb822b64326b6",
"assets/assets/icons/leaf5.svg": "98bd2095c39fce849e9c020f3c0ef762",
"assets/assets/icons/user.svg": "836e296c1af6485c3bbea800fc9d3299",
"assets/assets/icons/send.svg": "210de7eedeb56acd65e6675b7564e404",
"assets/assets/icons/chart1.svg": "cf08d30f20e7f62f769b6e905e7918db",
"assets/assets/icons/charger.svg": "3f27b684099dcbcea107f5bc26313eaf",
"assets/assets/icons/chat1.png": "167fc73ac652736812d8690c18116b30",
"assets/assets/icons/power.svg": "3388d94564ec690c9d5e4c1e49a258c0",
"assets/assets/icons/chart.svg": "3cf726cb07964c60854a9debc9f1c07f",
"assets/assets/icons/leaf1.svg": "8e1eed4ea373694291dc328cf288b331",
"assets/assets/icons/logo.svg": "23b9108d717be63e17be8e978526853f",
"assets/assets/icons/call.png": "6a30773de039189d5c3f372f1c680c02",
"assets/assets/icons/leaf8.svg": "3e7b6bae7537d322bfaa6f69836b3da4",
"assets/assets/icons/notify.svg": "0df049511e818b1749e4a5730a9704e3",
"assets/assets/icons/leaf6.svg": "32ddd212ccf984266f4d4354ca90c985",
"assets/assets/icons/edit.svg": "a6b8d4794d3a81371cc44f115174fb37",
"assets/assets/icons/bill.svg": "63d34dd01982c1a959ba6cb17a7c4f3d",
"assets/assets/icons/leaf7.svg": "cc10c7634535251c00ad6d67f5f55f18",
"assets/assets/icons/card.svg": "26e6748dac03026b81b75c01415374ce",
"assets/assets/icons/ocpp.png": "0c99e2c8efb5619c08829913e2c7240d",
"assets/assets/images/bg.jpg": "946204f5e83f7bb15f2547c7d6521a69",
"assets/assets/images/org1.jpg": "e3518d22df30534e73ac07981ae00530",
"assets/assets/images/error.svg": "b9f3ffd9cabf3146201b5cddee278449",
"assets/assets/images/charger1.jpg": "a94fc9743593cee836bdee0bb9fa22dc",
"assets/assets/images/bg6.jpeg": "b8f0913a1c5ab1a6086864e392fe6232",
"assets/assets/images/bill1.jpg": "60ebbe0b4a5c2e3e5f88fc086257b45b",
"assets/assets/images/stats1.jpg": "c0d29c9580cb0614a15a0fa692f53e00",
"assets/assets/images/error3.svg": "f5f40956918709735b21b9377ff7e341",
"assets/assets/images/users.jpg": "7f86bf2f34ddcf953fec6535f2abdcd3",
"assets/assets/images/bg1.jpg": "3e3592160d37b940ce29329505bb9da1",
"assets/assets/images/contact.jpg": "cd1153a529cd0736fd75c6e92ec5766f",
"assets/assets/images/mall.jpg": "5ef368f0c42adaebffde2ce87777d870",
"assets/assets/images/house.jpg": "50cd6a2bca30eba580816a8741d03b25",
"assets/assets/images/error2.svg": "f2648b4202a32bba56c40e0c29f4c640",
"assets/assets/images/company.jpg": "e706db84b4e16227202c21657f143193",
"assets/assets/images/error1.svg": "c278990da0125c456b2d3ca7d5dc7e7c",
"assets/assets/images/chsession.jpg": "6da47f32cf3a58baa772c96f1586e52c",
"assets/AssetManifest.json": "588b3b362b48a997f6dac255981ddf4e",
"assets/fonts/MaterialIcons-Regular.otf": "71e3a7760016def4a7459dcd204c0c33",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"flutter_bootstrap.js": "ef362616e27e5a73a2acb86d5344b8b0",
"version.json": "53c4614c899b3ade47c0d17984a980e3"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
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
        // Claim client to enable caching on first launch
        self.clients.claim();
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
      // Claim client to enable caching on first launch
      self.clients.claim();
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
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
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

# IOS Vast Client

IOS Vast Client is a Swift Framework which implements the [VAST 4.0](https://www.iab.com/guidelines/digital-video-ad-serving-template-vast/) spec.

This project is ongoing and in very early stages of development. As this project is being developed we will only target a subset of the VAST spec to meet our immediate needs. We do not recommend to use this library at this time. 

## Features

* VAST 4.0 Spec Complient, backwards compatible with Vast 3.0
* Vast XML Parser and Validator
* VAST Impression and Ad Tracking
* VAST Error Tracking

## API docs

iOS Vast Client contains 2 interfaces for public use.

### VastClient

Fetch and parse VAST file from URL. You can customize behaviour with `VastClientOptions` during initialization of `VastClient`.
If you would like to cache the VMAPModel to prevent duplicate calls, change the value of shouldCacheVMAPModel to true.

`VastClient` result is `VastModel` structure or `Error` in case the fetch failed. You should pass this model to `VastTracker`.

### VastTracker

Handles tracking of ad quartiles. Performs tracking for ads/ad breaks. Notifies quartile state updates via delegate calls.

#### Initialization

Init `VastTracker` with `VastModel` structure but always make sure to use the actual `VastAd` and other information provided via delegate function calls - do not keep the `VastModel` as not all information from the `VastModel` might be valid for playback etc. 

#### Progress and Ad Tracking

`func updateProgress(time: Double) throws`
After you initialize `VastTracker` you should call this function with `time = playhead` parameter to start tracking process. Playhead should match the playhead value used in intialization of `VastTracker`.  (If you simply want to play pre-roll ads before your content, initialize `VastTracker` with `playhead = 0` and call `updateProgress(time:)` with `time = 0`)

You have to call this function periodically during ad playback.

Your client must track when ads/ad breaks start and end. You can pass this information to `Vast Tracker` via the following
- `func trackAdBreakStart(for adBreak: VMAPAdBreak)`
- `func trackAdBreakEnd(for adBreak: VMAPAdBreak)`
- `func trackAdStart(withId id: String) throws`
- `func trackAdComplete() throws`

`VastTracker` will track quartile updates while `func updateProgress(time: Double) throws` is being called.


These delegate functions will be called during normal ad playback and you do not have to react to them - they are only informative

```swift
func adFirstQuartile(vastTracker: VastTracker, ad: VastAd)
func adMidpoint(vastTracker: VastTracker, ad: VastAd)
func adThirdQuartile(vastTracker: VastTracker, ad: VastAd)
```

### Other Tracking

During ad break, other actions might be invoked by the user or the system.
`VastTracker` support tracking of these actions:

```
public func paused(_ val: Bool)
public func fullscreen(_ val: Bool)
public func rewind()
public func muted(_ val: Bool)
public func acceptedLinearInvitation()
public func closed()
public func clicked() -> URL?
public func clickedWithCustomAction() -> [URL]
public func error(withReason code: VastErrorCodes?)
```

## Supported tags

status:

- not parsed
- parsed - but not used currently, can be used by host app
- partial - partially supported - might be missing edge cases
- full - fully supported VAST tag

|tag|status|note|
|---|---|---|
|VAST|full|-|
|Ad|partial|single and AdPods supported, AdBuffet treated like single ad|
|InLine|full|-|
|AdSystem|parsed||
|AdTitle|full||
|Impression|parsed||
|Category|parsed||
|Description|parsed||
|Advertiser|parsed||
|Pricing|parsed||
|Survey|parsed||
|Error|full|host app needs to initiate the error tracking|
|ViewableImpression|full|host app needs to call tracking function with appropriate type at appropriate time|
|Creatives|full||
|Creative|full||
|UniversalAdId|parsed||
|CreativeExtensions|parsed||
|CreativeExtension|parsed||
|Linear|full||
|Duration|full||
|AdParameters|parsed|but only as a string - this might be XML content that will need validation if it is necessary for use|
|MediaFiles|full||
|MediaFile|parsed|up to host app to handle playback|
|Mezzanine|not parsed||
|InteractiveCreativeFile|parsed||
|VideoClicks|full|host app has to initiate tracking events for clicks|
|ClickThrough|full||
||ClickTracking|full|
|CustomClick|partial|host app can track custom clicks via tracker, but the functionality is not specified|
|Icons|partial|iFrame and HTML resources not parsed|
|Icon|full|host app has to handle icon placement, visibility and icon clicks|
|IconViewTracking|parsed|View action tracking not implemented|
|IconClicks|full||
|IconClickThrough|full||
|IconClickTracking|full||
|NonLinearAds|not parsed|no sub-elements supported|
|CompanionAds|not parsed|no sub-elements supported|
|Wrapper|full||
|VASTAdTagURI|parsed||
|CompanionAds|parsed||
|Companion|parsed|all subelements parsed but CompanionClickTracking does not support `id` attribute|


## Getting Started

Check out the VastClientWrapper project for example implementation

## Contributing

Please read [CONTRIBUTING.md](https://github.com/realeyes-media/ios-vast-client/CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## License

This project is licensed under the MIT License - see [LICENSE](https://github.com/realeyes-media/ios-vast-client/LICENSE) file for details

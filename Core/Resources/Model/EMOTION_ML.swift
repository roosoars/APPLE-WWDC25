//
//  EMOTION_ML.swift
//  FaceQuiz
//
//  Created by Rodrigo Soares on 29/01/25.
//

//
// EMOTION_ML.swift
//
// This file was automatically generated and should not be edited.
//

import CoreML


/// Model Prediction Input Type
@available(macOS 14.0, iOS 17.0, tvOS 17.0, visionOS 1.0, *)
@available(watchOS, unavailable)
class EMOTION_MLInput : MLFeatureProvider {
    
    /// image as color (kCVPixelFormatType_32BGRA) image buffer, 360 pixels wide by 360 pixels high
    var image: CVPixelBuffer
    
    var featureNames: Set<String> { ["image"] }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        if featureName == "image" {
            return MLFeatureValue(pixelBuffer: image)
        }
        return nil
    }
    
    init(image: CVPixelBuffer) {
        self.image = image
    }
    
    convenience init(imageWith image: CGImage) throws {
        self.init(image: try MLFeatureValue(cgImage: image, pixelsWide: 360, pixelsHigh: 360, pixelFormatType: kCVPixelFormatType_32BGRA, options: nil).imageBufferValue!)
    }
    
    convenience init(imageAt image: URL) throws {
        self.init(image: try MLFeatureValue(imageAt: image, pixelsWide: 360, pixelsHigh: 360, pixelFormatType: kCVPixelFormatType_32BGRA, options: nil).imageBufferValue!)
    }
    
    func setImage(with image: CGImage) throws  {
        self.image = try MLFeatureValue(cgImage: image, pixelsWide: 360, pixelsHigh: 360, pixelFormatType: kCVPixelFormatType_32BGRA, options: nil).imageBufferValue!
    }
    
    func setImage(with image: URL) throws  {
        self.image = try MLFeatureValue(imageAt: image, pixelsWide: 360, pixelsHigh: 360, pixelFormatType: kCVPixelFormatType_32BGRA, options: nil).imageBufferValue!
    }
    
}


/// Model Prediction Output Type
@available(macOS 14.0, iOS 17.0, tvOS 17.0, visionOS 1.0, *)
@available(watchOS, unavailable)
class EMOTION_MLOutput : MLFeatureProvider {
    
    /// Source provided by CoreML
    private let provider : MLFeatureProvider
    
    /// target as string value
    var target: String {
        provider.featureValue(for: "target")!.stringValue
    }
    
    /// targetProbability as dictionary of strings to doubles
    var targetProbability: [String : Double] {
        provider.featureValue(for: "targetProbability")!.dictionaryValue as! [String : Double]
    }
    
    var featureNames: Set<String> {
        provider.featureNames
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        provider.featureValue(for: featureName)
    }
    
    init(target: String, targetProbability: [String : Double]) {
        self.provider = try! MLDictionaryFeatureProvider(dictionary: ["target" : MLFeatureValue(string: target), "targetProbability" : MLFeatureValue(dictionary: targetProbability as [AnyHashable : NSNumber])])
    }
    
    init(features: MLFeatureProvider) {
        self.provider = features
    }
}


/// Class for model loading and prediction
@available(macOS 14.0, iOS 17.0, tvOS 17.0, visionOS 1.0, *)
@available(watchOS, unavailable)
class EMOTION_ML {
    let model: MLModel
    
    /// URL of model assuming it was installed in the same bundle as this class
    class var urlOfModelInThisBundle : URL {
        let bundle = Bundle(for: self)
        return bundle.url(forResource: "EMOTION_ML", withExtension:"mlmodelc")!
    }
    
    /**
     Construct EMOTION_ML instance with an existing MLModel object.
     
     Usually the application does not use this initializer unless it makes a subclass of EMOTION_ML.
     Such application may want to use `MLModel(contentsOfURL:configuration:)` and `EMOTION_ML.urlOfModelInThisBundle` to create a MLModel object to pass-in.
     
     - parameters:
     - model: MLModel object
     */
    init(model: MLModel) {
        self.model = model
    }
    
    /**
     Construct a model with configuration
     
     - parameters:
     - configuration: the desired model configuration
     
     - throws: an NSError object that describes the problem
     */
    convenience init(configuration: MLModelConfiguration = MLModelConfiguration()) throws {
        try self.init(contentsOf: type(of:self).urlOfModelInThisBundle, configuration: configuration)
    }
    
    /**
     Construct EMOTION_ML instance with explicit path to mlmodelc file
     - parameters:
     - modelURL: the file url of the model
     
     - throws: an NSError object that describes the problem
     */
    convenience init(contentsOf modelURL: URL) throws {
        try self.init(model: MLModel(contentsOf: modelURL))
    }
    
    /**
     Construct a model with URL of the .mlmodelc directory and configuration
     
     - parameters:
     - modelURL: the file url of the model
     - configuration: the desired model configuration
     
     - throws: an NSError object that describes the problem
     */
    convenience init(contentsOf modelURL: URL, configuration: MLModelConfiguration) throws {
        try self.init(model: MLModel(contentsOf: modelURL, configuration: configuration))
    }
    
    /**
     Construct EMOTION_ML instance asynchronously with optional configuration.
     
     Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.
     
     - parameters:
     - configuration: the desired model configuration
     - handler: the completion handler to be called when the model loading completes successfully or unsuccessfully
     */
    class func load(configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<EMOTION_ML, Error>) -> Void) {
        load(contentsOf: self.urlOfModelInThisBundle, configuration: configuration, completionHandler: handler)
    }
    
    /**
     Construct EMOTION_ML instance asynchronously with optional configuration.
     
     Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.
     
     - parameters:
     - configuration: the desired model configuration
     */
    class func load(configuration: MLModelConfiguration = MLModelConfiguration()) async throws -> EMOTION_ML {
        try await load(contentsOf: self.urlOfModelInThisBundle, configuration: configuration)
    }
    
    /**
     Construct EMOTION_ML instance asynchronously with URL of the .mlmodelc directory with optional configuration.
     
     Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.
     
     - parameters:
     - modelURL: the URL to the model
     - configuration: the desired model configuration
     - handler: the completion handler to be called when the model loading completes successfully or unsuccessfully
     */
    class func load(contentsOf modelURL: URL, configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<EMOTION_ML, Error>) -> Void) {
        MLModel.load(contentsOf: modelURL, configuration: configuration) { result in
            switch result {
            case .failure(let error):
                handler(.failure(error))
            case .success(let model):
                handler(.success(EMOTION_ML(model: model)))
            }
        }
    }
    
    /**
     Construct EMOTION_ML instance asynchronously with URL of the .mlmodelc directory with optional configuration.
     
     Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.
     
     - parameters:
     - modelURL: the URL to the model
     - configuration: the desired model configuration
     */
    class func load(contentsOf modelURL: URL, configuration: MLModelConfiguration = MLModelConfiguration()) async throws -> EMOTION_ML {
        let model = try await MLModel.load(contentsOf: modelURL, configuration: configuration)
        return EMOTION_ML(model: model)
    }
    
    /**
     Make a prediction using the structured interface
     
     It uses the default function if the model has multiple functions.
     
     - parameters:
     - input: the input to the prediction as EMOTION_MLInput
     
     - throws: an NSError object that describes the problem
     
     - returns: the result of the prediction as EMOTION_MLOutput
     */
    func prediction(input: EMOTION_MLInput) throws -> EMOTION_MLOutput {
        try prediction(input: input, options: MLPredictionOptions())
    }
    
    /**
     Make a prediction using the structured interface
     
     It uses the default function if the model has multiple functions.
     
     - parameters:
     - input: the input to the prediction as EMOTION_MLInput
     - options: prediction options
     
     - throws: an NSError object that describes the problem
     
     - returns: the result of the prediction as EMOTION_MLOutput
     */
    func prediction(input: EMOTION_MLInput, options: MLPredictionOptions) throws -> EMOTION_MLOutput {
        let outFeatures = try model.prediction(from: input, options: options)
        return EMOTION_MLOutput(features: outFeatures)
    }
    
    /**
     Make an asynchronous prediction using the structured interface
     
     It uses the default function if the model has multiple functions.
     
     - parameters:
     - input: the input to the prediction as EMOTION_MLInput
     - options: prediction options
     
     - throws: an NSError object that describes the problem
     
     - returns: the result of the prediction as EMOTION_MLOutput
     */
    func prediction(input: EMOTION_MLInput, options: MLPredictionOptions = MLPredictionOptions()) async throws -> EMOTION_MLOutput {
        let outFeatures = try await model.prediction(from: input, options: options)
        return EMOTION_MLOutput(features: outFeatures)
    }
    
    /**
     Make a prediction using the convenience interface
     
     It uses the default function if the model has multiple functions.
     
     - parameters:
     - image: color (kCVPixelFormatType_32BGRA) image buffer, 360 pixels wide by 360 pixels high
     
     - throws: an NSError object that describes the problem
     
     - returns: the result of the prediction as EMOTION_MLOutput
     */
    func prediction(image: CVPixelBuffer) throws -> EMOTION_MLOutput {
        let input_ = EMOTION_MLInput(image: image)
        return try prediction(input: input_)
    }
    
    /**
     Make a batch prediction using the structured interface
     
     It uses the default function if the model has multiple functions.
     
     - parameters:
     - inputs: the inputs to the prediction as [EMOTION_MLInput]
     - options: prediction options
     
     - throws: an NSError object that describes the problem
     
     - returns: the result of the prediction as [EMOTION_MLOutput]
     */
    func predictions(inputs: [EMOTION_MLInput], options: MLPredictionOptions = MLPredictionOptions()) throws -> [EMOTION_MLOutput] {
        let batchIn = MLArrayBatchProvider(array: inputs)
        let batchOut = try model.predictions(from: batchIn, options: options)
        var results : [EMOTION_MLOutput] = []
        results.reserveCapacity(inputs.count)
        for i in 0..<batchOut.count {
            let outProvider = batchOut.features(at: i)
            let result =  EMOTION_MLOutput(features: outProvider)
            results.append(result)
        }
        return results
    }
}

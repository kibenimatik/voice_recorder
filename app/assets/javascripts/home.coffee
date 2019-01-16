document.addEventListener 'DOMContentLoaded', (event) ->

  URL = window.URL or window.webkitURL
  gumStream = undefined
  rec = undefined
  input = undefined

  ###
    MediaStreamAudioSourceNode we'll be recording
    shim for AudioContext when it's not avb.
  ###
  AudioContext = window.AudioContext or window.webkitAudioContext
  audioContext = undefined

  startRecording = ->
    console.log 'recordButton clicked'

    constraints =
      audio: true
      video: false

    ###
      Disable the record button until we get a success or fail from getUserMedia()
    ###
    recordButton.disabled = true
    stopButton.disabled = false

    navigator.mediaDevices.getUserMedia(constraints).then((stream) ->
      console.log 'getUserMedia() success, stream created, initializing Recorder.js ...'

      audioContext = new AudioContext

      ###
        Assign to gumStream for later use in stopButton()
      ###
      gumStream = stream

      input = audioContext.createMediaStreamSource(stream)

      ###
        Create the Recorder object and configure to record mono sound (1 channel)
        Recording 2 channels  will double the file size
      ###
      rec = new Recorder(input, numChannels: 1, workerPath: '/recorderWorker.js')

      ###
        Start the recording process
      ###
      rec.record()
      console.log 'Recording started'
      return
    ).catch (err) ->
      # Enable the record button if getUserMedia() fails
      recordButton.disabled = false
      stopButton.disabled = true
      return
    return

  stopRecording = ->
    console.log 'stopButton clicked'

    ###
      Disable the stop button, enable the record too allow for new recordings
    ###
    stopButton.disabled = true
    recordButton.disabled = false

    ###
      Tell the recorder to stop the recording
    ###
    rec.stop()

    ###
      Stop microphone access
    ###
    gumStream.getAudioTracks()[0].stop()

    ###
      Create the wav blob and pass it on to createUploadButton
    ###
    rec.exportWAV createUploadButton
    return

  createUploadButton = (blob) ->
    url = URL.createObjectURL(blob)

    wrapper = document.createElement('div')
    wrapper.className = "well"

    audioTag = document.createElement('audio')
    audioTag.controls = true
    audioTag.src = url

    wrapper.appendChild audioTag

    ###
      Name of .wav file needs for Shrine for correct path calculation
    ###
    filename = (new Date).toISOString() + '.wav'

    uploadButton = document.createElement('a')
    uploadButton.className = "btn btn-primary"
    uploadButton.href = '#'
    uploadButton.innerHTML = 'Upload'
    uploadButton.addEventListener 'click', (event) ->
      xhr = new XMLHttpRequest

      xhr.onload = (e) ->
        if @readyState == 4
          alert('Uploaded!')
        return

      fd = new FormData
      fd.append 'audio', blob, filename
      xhr.open 'POST', '/upload', true
      xhr.send fd
      return

    ###
      wrapper.appendChild document.createTextNode(' ')
    ###

    wrapper.appendChild uploadButton

    recordingsList.appendChild wrapper
    return

  ###
    Define buttons
  ###
  recordButton = document.getElementById('recordButton')
  stopButton = document.getElementById('stopButton')

  ###
    Add events to those 2 buttons
  ###
  if typeof recordButton != 'undefined' and recordButton != null
    recordButton.addEventListener 'click', startRecording

  if typeof stopButton != 'undefined' and stopButton != null
    stopButton.addEventListener 'click', stopRecording

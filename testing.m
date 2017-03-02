% first try to continuously update buffer
[s,fs] = setupNI_analog([0 1],400e3);

% make some data that you want to alternate
params.filt         = load('SMALL_BOOTH_FILT_70dB_200-9e3kHZ');
params.filt         = params.filt.filt;
params.amp70        = .1;
params.rampD        = .005;
params.nTones       = 34;
params.freqs        = 10^3 * (2 .^ (([0:params.nTones-1])/6)); % this is n freqs spaced 1/6 octave apart
params.mu           = 50;
params.sd           = [15 5];
params.chordDuration = .025;
params.noiseDuration = 3;
for i = 1:2
    [noise(i,:) events] = makeDRC(fs,params.rampD,params.chordDuration,...
        params.noiseDuration,params.freqs,params.mu,params.sd(i),...
        params.amp70,params.filt);
end

% now play it continuously, alternating each block
cnt = 2;
lh = addlistener(s,'DataRequired',@(src,event,noise,events,cnt) addData2Queue);
s.IsContinuous = true;
queueOutputData(s,[noise(1,:); events]');
s.startBackground();

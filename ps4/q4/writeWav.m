function writeWav( prefix, data, Fs )

v = version;
if (v(1) <= '3') % assume this is octave
    wavwrite([prefix '1.wav'], data(:, 1), Fs, 16);
	wavwrite([prefix '2.wav'], data(:, 2), Fs, 16);
	wavwrite([prefix '3.wav'], data(:, 3), Fs, 16);
	wavwrite([prefix '4.wav'], data(:, 4), Fs, 16);
	wavwrite([prefix '5.wav'], data(:, 5), Fs, 16);
else
	wavwrite(data(:, 1), Fs, 16, [prefix '1.wav']);
	wavwrite(data(:, 2), Fs, 16, [prefix '2.wav']);
	wavwrite(data(:, 3), Fs, 16, [prefix '3.wav']);
    wavwrite(data(:, 4), Fs, 16, [prefix '4.wav']);
    wavwrite(data(:, 5), Fs, 16, [prefix '5.wav']);
end

end


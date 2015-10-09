package com.vox.gospel.media {

import flash.utils.ByteArray;
import flash.utils.Endian;

public class WaveCodec {
    public function WaveCodec() {
    }


    static private function resampling(fromSamples:Vector.<Number>, fromSampleRate:int, toSampleRate:int, quality:int = 10):ByteArray {
        //var samples:Vector.<Number> = new Vector.<Number>;
        //var srcLength:uint = this._samples.length;
        //var destLength:uint = this._samples.length*toSampleRate/fromSampleRate;
        var srcLength:uint = fromSamples.length;
        var destLength:uint = fromSamples.length * toSampleRate / fromSampleRate;
        var toSamples:ByteArray = new ByteArray();

        var dx:Number = srcLength / destLength;

        // fmax : nyqist half of destination sampleRate
        // fmax / fsr = 0.5;
        var fmaxDivSR:Number = 0.5;
        var r_g:Number = 2 * fmaxDivSR;

        // Quality is half the window width
        var wndWidth2:int = quality;
        var wndWidth:int = quality * 2;

        var x:Number = 0;
        var i:uint, j:uint;
        var r_y:Number;
        var tau:int;
        var r_w:Number;
        var r_a:Number;
        var r_snc:Number;
        for (i = 0; i < destLength; ++i) {
            r_y = 0.0;
            for (tau = -wndWidth2; tau < wndWidth2; ++tau) {
                j = (int)(x + tau); // input sample index

                // Hann Window. Scale and calculate sinc
                r_w = 0.5 - 0.5 * Math.cos(2 * Math.PI * (0.5 + (j - x) / wndWidth));
                r_a = 2 * Math.PI * (j - x) * fmaxDivSR;
                r_snc = 1.0;
                if (r_a != 0) r_snc = Math.sin(r_a) / r_a;

                if ((j >= 0) && (j < srcLength))
                    r_y += r_g * r_w * r_snc * fromSamples[j];
            }
            //trace(fromSamples[j]); trace(r_y);
            //toSamples[i] = r_y;
            //toSamples.push(r_y);
            toSamples.writeFloat(r_y);
            toSamples.writeFloat(r_y);

            x += dx;
        }
        return toSamples;
    }


    static private var adpcmStepIndexAdjust:Array = [-1, -1, -1, -1, 2, 4, 6, 8, -1, -1, -1, -1, 2, 4, 6, 8];
    static private var adpcmStepTable:Array = [7, 8, 9, 10, 11, 12, 13, 14, 16, 17, 19, 21, 23, 25, 28, 31, 34, 37, 41, 45, 50, 55, 60, 66, 73, 80, 88, 97, 107, 118, 130, 143, 157, 173, 190, 209, 230, 253, 279, 307, 337, 371, 408, 449, 494, 544, 598, 658, 724, 796, 876, 963, 1060, 1166, 1282, 1411, 1552, 1707, 1878, 2066, 2272, 2499, 2749, 3024, 3327, 3660, 4026, 4428, 4871, 5358, 5894, 6484, 7132, 7845, 8630, 9493, 10442, 11487, 12635, 13899, 15289, 16818, 18500, 20350, 22385, 24623, 27086, 29794, 32767];


    // 读取非压缩的wav文件内容
    public static function parseWaveData(data:ByteArray):Object {
        data.endian = Endian.LITTLE_ENDIAN;
        data.position = 0;
        var result:Object = new Object();
        result['header'] = new Object();
        var riff:String = data.readUTFBytes(4);
        result['header']['filesize'] = data.readUnsignedInt();
        var filetype:String = data.readUTFBytes(4);
        if (riff == 'RIFF' && filetype == 'WAVE') {
            while (data.position + 4 <= data.length) {
                var type:String = data.readUTFBytes(4);
                switch (type) {
                    case 'fmt ':
                    {
                        result['fmt'] = new Object();
                        result['fmt']['chunksize'] = data.readUnsignedInt();
                        result['fmt']['formatid'] = data.readUnsignedShort();
                        result['fmt']['channel'] = data.readUnsignedShort();
                        result['fmt']['samplerate'] = data.readUnsignedInt();
                        result['fmt']['byterate'] = data.readUnsignedInt();
                        result['fmt']['blockalign'] = data.readUnsignedShort();
                        result['fmt']['bitspersample'] = data.readUnsignedShort();
                        if (result['fmt']['formatid'] != 1)  // only non-PCM has the extrasize
                        {
                            result['fmt']['extrasize'] = data.readUnsignedShort();
                            if (result['fmt']['formatid'] == 0x11) // IMA-ADPCM
                            {
                                result['fmt']['samplesPerBlock'] = data.readUnsignedShort();
                            }
                        }
                        break;
                    }
                    case 'fact':
                    {
                        result['fact'] = new Object();
                        result['fact']['chunksize'] = data.readUnsignedInt();
                        result['fact']['data'] = data.readUTFBytes(result['fact']['chunksize']);
                        break;
                    }
                    case 'data':
                    {
                        result['data'] = new Object();
                        result['data']['chunksize'] = data.readUnsignedInt();

                        var samples:Vector.<Number> = new Vector.<Number>();
                        var i:int;
                        switch (result['fmt']['bitspersample']) {
                            case 4:
                            {
                                //only for IMA-ADPCM now
                                var chunksize:int = result['data']['chunksize'];
                                var b:int;
                                var bi:int;
                                var code:int = 0;
                                var signBit:int = 0;
                                var delta:int = 0;
                                var curSample:int = 0;
                                var step:int = 0;
                                var stepIndex:int = 0;

                                var nblocks:int = Math.ceil(chunksize / result['fmt']['blockalign']);
                                var nSampleBlock:int = result['fmt']['samplesPerBlock'];

                                nSampleBlock--; // remove the sample in block header
                                for (var blockIndex:int = 0; blockIndex < nblocks; blockIndex++) {
                                    if (data.bytesAvailable == 0)
                                        break;

                                    curSample = data.readShort();

                                    samples.push(curSample / 32768);

                                    stepIndex = data.readShort();
                                    if (stepIndex < 0) stepIndex = 0;
                                    else if (stepIndex > 88) stepIndex = 88;

                                    for (var nSample:int = nSampleBlock; nSample > 0; nSample -= 2) {
                                        if (data.bytesAvailable == 0)
                                            break;

                                        b = data.readByte() & 0xFF;
                                        var bs:Array = [b & 0x0F, (b & 0xF0) / 16];
                                        for (bi = 0; bi < 2; bi++) {
                                            code = bs[bi];

                                            // =============== METHOD 1 ================
                                            signBit = ((code & 8) != 0) ? 1 : 0;
                                            code &= 7;

                                            delta = (adpcmStepTable[stepIndex] * code) * 0.25 + adpcmStepTable[stepIndex] * 0.125
                                            if (signBit == 1)
                                                delta = -delta;

                                            curSample += delta;

                                            if (curSample > 32767) curSample = 32767;
                                            else if (curSample < -32768) curSample = -32768;

                                            stepIndex += adpcmStepIndexAdjust[code];
                                            if (stepIndex < 0) stepIndex = 0;
                                            else if (stepIndex > 88) stepIndex = 88;


                                            /*
                                             // =============== METHOD 2 ================
                                             delta = 0;
                                             if (code & 4) delta += adpcmStepTable[stepIndex];
                                             if (code & 2) delta += (adpcmStepTable[stepIndex] >> 1);
                                             if (code & 1) delta += (adpcmStepTable[stepIndex] >> 2);
                                             delta += (adpcmStepTable[stepIndex] >> 3);
                                             if (code & 8) delta = -delta;
                                             curSample += delta;

                                             if (curSample > 32767) curSample = 32767;
                                             else if (curSample < -32768) curSample=-32768;

                                             stepIndex += adpcmStepIndexAdjust[code];
                                             if (stepIndex < 0) stepIndex = 0;
                                             else if (stepIndex > 88) stepIndex = 88;
                                             */

                                            /*
                                             // =============== METHOD 3 ================
                                             // Step 2 - Find new index value (for later)
                                             stepIndex += stepIndexAdjust[code];
                                             if ( stepIndex < 0 ) stepIndex = 0;
                                             if ( stepIndex > 88 ) stepIndex = 88;

                                             // Step 3 - Separate sign and magnitude
                                             signBit = code & 8;
                                             code = code & 7;

                                             // Step 4 - Compute difference and new predicted value
                                             // Computes 'vpdiff = (delta+0.5)*step/4', but see comment in adpcm_coder.
                                             var vpdiff : int = step >> 3;
                                             if ( code & 4 ) vpdiff += step;
                                             if ( code & 2 ) vpdiff += step>>1;
                                             if ( code & 1 ) vpdiff += step>>2;

                                             if ( signBit ) curSample -= vpdiff;
                                             else curSample += vpdiff;

                                             // Step 5 - clamp output value
                                             if ( curSample > 32767 ) curSample = 32767;
                                             else if ( curSample < -32768 ) curSample = -32768;

                                             // Step 6 - Update step value
                                             step = stepTable[stepIndex];

                                             // Step 7 - Output value
                                             */

                                            //trace(curSample);
                                            samples.push(curSample / 32768);
                                        }
                                    }
                                }
                                break;
                            }
                            case 8:
                            {
                                for (i = 0; i < result['data']['chunksize']; i++)
                                    samples.push(data.readByte() / 128);
                                break;
                            }
                            case 16:
                            {
                                for (i = 0; i < result['data']['chunksize'] / 2; i++)
                                    samples.push(data.readShort() / 32768);
                                break;
                            }
                            /*
                             default:
                             var bit:uint = result['fmt']['bitspersample'];
                             var byte:uint = result['fmt']['bitspersample'] / 8;
                             var minus_value:Number = 1 << (bit - 1);
                             for (i = 0; i < result['data']['chunksize'] / byte; i++)
                             {
                             var j:int;
                             var value:Number = 0;
                             for (j = 0; j < byte; j++)
                             {
                             value += data.readUnsignedByte() << (8 * j);
                             }
                             if (minus_value <= value)
                             {
                             value -= minus_value + minus_value;
                             }
                             value /= minus_value + minus_value;
                             result['data']['data'].push(value);
                             }
                             break;
                             */
                        }

                        result['data']['data'] = samples;
                        result['data']['data44100'] = resampling(samples, 8000, 44100, 5);
                        result['data']['data44100'].position = 0; // 这个采样效果更好一点，但是极慢
                        break;
                    }
                    case 'LIST':
                    {
                        result['list'] = new Object();
                        result['list']['chunksize'] = data.readUnsignedInt();
                        result['list']['info'] = data.readUTFBytes(4);
                        while (result['list']['chunksize'] <= data.length) {
                            var fourcc:String = data.readUTFBytes(4);
                            result['list'][fourcc] = new Object();
                            result['list'][fourcc]['chunksize'] = data.readUnsignedInt();
                            result['list'][fourcc]['data'] = new ByteArray();
                            result['list'][fourcc]['data'].writeBytes(data, data.position, uint(result['list'][fourcc]['chunksize']));
                            data.position += result['list'][fourcc]['chunksize'];
                            result['list'][fourcc]['data'].position = 0;
                        }
                        break;
                    }
                    default:
                        break;
                }
                if (data.position % 2 == 1) {
                    data.position++;
                }
            }
        }
        return result;
    }


    static public function compressRecordDataToWaveImaAdpcm(data:ByteArray):ByteArray {
        if(! data)
            return null;

        var output:ByteArray = new ByteArray();
        output.endian = Endian.LITTLE_ENDIAN;

        var floatSize:int = 4;
        var totalSamples8000:int = Math.floor(data.length / floatSize / 11);

        //fmt
        var bitsPerSample:int = 4;
        var blockAlign:int = 256;
        var byteRate:int = 4055;
        var channel:int = 1;
        var fmtChunkSize:int = 20;
        var fmtExtraSize:int = 2;
        var formatId:int = 0x11;
        var sampleRate:int = 8000;
        var samplesPerBlock:int = 505;

        var factChunkSize:int = 4;
        var factDataFactSize:int = totalSamples8000 * 2; //数据转换为PCM格式后的大小。16bit mono

        var nblock:int = Math.ceil(totalSamples8000 / samplesPerBlock);
        var blockSize:int = 4 + ((samplesPerBlock - 1) / 2);
        var dataChunkSize:int = Math.floor(blockSize * totalSamples8000 / samplesPerBlock);

        var outputHead:ByteArray = new ByteArray();
        outputHead.endian = Endian.LITTLE_ENDIAN;
        outputHead.writeUTFBytes("WAVE");
        outputHead.writeUTFBytes("fmt ");
        outputHead.writeInt(fmtChunkSize);
        outputHead.writeShort(formatId);
        outputHead.writeShort(channel);
        outputHead.writeInt(sampleRate);
        outputHead.writeInt(byteRate);
        outputHead.writeShort(blockAlign);
        outputHead.writeShort(bitsPerSample);
        outputHead.writeShort(fmtExtraSize);
        outputHead.writeShort(samplesPerBlock);

        outputHead.writeUTFBytes("fact");
        outputHead.writeInt(factChunkSize);
        outputHead.writeInt(factDataFactSize);

        output.writeUTFBytes("RIFF");
        output.writeInt(outputHead.length + 4/*data*/ + 4/*dataChunkSize*/ + dataChunkSize);
        output.writeBytes(outputHead, 0, outputHead.length);
        output.writeUTFBytes("data");
        output.writeInt(dataChunkSize);

        var outputSizeBeforeWavData:int = output.length;

        data.position = 0;
        var stepIndex:int = 0;
        var tmp:int = 0;
        var curSample:int = 0;
        var prevSample:int = 0;
        for (; nblock > 0; nblock--) {
            //44100 to 8000
            for (tmp = 0; tmp < 11; tmp++) {
                if (data.bytesAvailable < floatSize) break;
                curSample = data.readFloat() * 32767;
            }
            var delta:int = 0;
            var signBit:int = 0;
            var code:int = 0;
            var diff:int = 0;
            var vpdiff:int = 0;
            var step:int = 0;

            output.writeShort(curSample);
            output.writeShort(stepIndex);

            prevSample = curSample;

            for (var nSamp:int = samplesPerBlock - 1; nSamp > 0; nSamp -= 2) {
                var b:int = 0;
                for (var bi:int = 0; bi < 2; bi++) {
                    //44100 to 8000
                    for (tmp = 0; tmp < 11; tmp++) {
                        if (data.bytesAvailable < floatSize) break;
                        curSample = data.readFloat() * 32767;
                    }

                    /*
                     // METHOD 1 , buggy, prevSample may be in wrong state
                     delta = curSample - prevSample;
                     if (delta < 0)
                     {
                     delta = -delta;
                     signBit = 8;
                     }
                     else signBit=0;

                     code = 4 * delta / adpcmStepTable[stepIndex];
                     if (code>7) code=7;

                     stepIndex += adpcmStepIndexAdjust[code];
                     if (stepIndex<0) stepIndex=0;
                     else if (stepIndex>88) stepIndex=88;

                     prevSample = curSample;
                     code |= signBit;
                     */

                    // Step 1 - compute difference with previous value
                    diff = curSample - prevSample;
                    signBit = (diff < 0) ? 8 : 0;
                    if (signBit) diff = (-diff);

                    // Step 2 - Divide and clamp
                    step = adpcmStepTable[stepIndex];
                    code = 0;
                    vpdiff = (step >> 3);

                    if (diff >= step) {
                        code = 4;
                        diff -= step;
                        vpdiff += step;
                    }
                    step >>= 1;
                    if (diff >= step) {
                        code |= 2;
                        diff -= step;
                        vpdiff += step;
                    }
                    step >>= 1;
                    if (diff >= step) {
                        code |= 1;
                        vpdiff += step;
                    }

                    // Step 3 - Update previous value
                    if (signBit)
                        prevSample -= vpdiff;
                    else
                        prevSample += vpdiff;

                    // Step 4 - Clamp previous value to 16 bits
                    if (prevSample > 32767)
                        prevSample = 32767;
                    else if (prevSample < -32768)
                        prevSample = -32768;

                    // Step 5 - Assemble value, update index and step values
                    code |= signBit;

                    stepIndex += adpcmStepIndexAdjust[code];
                    if (stepIndex < 0) stepIndex = 0;
                    if (stepIndex > 88) stepIndex = 88;

                    // Step 6 - Output value
                    b = b | (code << (bi * 4));
                }
                output.writeByte(b);
            }
        }

        output.length = ( outputSizeBeforeWavData + dataChunkSize);
        return output;
    }
}
}

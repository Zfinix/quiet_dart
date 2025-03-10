package com.chizi.data_over_sound;

import android.content.Context;

import org.quietmodem.Quiet.FrameReceiver;
import org.quietmodem.Quiet.FrameReceiverConfig;

import java.net.SocketTimeoutException;

import rx.Observable;
import rx.Subscription;

public class FrameReceiverObservable {

    private static final int TIEMOUT = 0;
    private static final int BUFFER_SIZE = 1024;

    public static Observable<byte[]> create(Context context, String profile) {
        return Observable.create(subscriber -> {
            try {
                FrameReceiverConfig receiverConfig = new FrameReceiverConfig(context, profile);
                 FrameReceiver frameReceiver = new FrameReceiver(receiverConfig);
                frameReceiver.setBlocking(TIEMOUT, 0);
                final byte[] buf = new byte[BUFFER_SIZE];

                subscriber.add(new Subscription() {
                    public boolean isUnsubscribed;

                    @Override
                    public void unsubscribe() {
                        frameReceiver.close();
                        isUnsubscribed = true;
                    }

                    @Override
                    public boolean isUnsubscribed() {
                        return isUnsubscribed;
                    }
                });

                while(!subscriber.isUnsubscribed()) {
                    long revLen = 0;
                    try {
                        revLen = frameReceiver.receive(buf);
                        byte[] immutableBuf = java.util.Arrays.copyOf(buf, (int)revLen);
                        subscriber.onNext(immutableBuf);
                    } catch (SocketTimeoutException e ) {
                        // ignore timeouts - attempt new receive
                    }
                }

            } catch (Exception e) {
                subscriber.onError(e);
            }

        });
    }
}

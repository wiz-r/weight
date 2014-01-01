package com.wizr.weightlogger.fragment;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.RelativeLayout;

import com.wizr.weightlogger.MainActivity;
import com.wizr.weightlogger.R;
import com.google.android.gms.ads.*;

/**
 * Created by takuya.watabe on 8/6/13.
 */
public class MainFragment extends Fragment {
    private AdView adView;

    public MainFragment() {
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_main, container, false);
        RelativeLayout layout = (RelativeLayout)rootView;
        Button inputButton = (Button)rootView.findViewById(R.id.button_input_weight);
        inputButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                MainActivity activity = (MainActivity)getActivity();
                activity.showInputDialog();
            }
        });

        // ad
        adView = new AdView(getActivity());
        adView.setAdSize(AdSize.BANNER);
        adView.setAdUnitId("ca-app-pub-6380416780677658/7170803781");
        RelativeLayout.LayoutParams p = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.WRAP_CONTENT, RelativeLayout.LayoutParams.WRAP_CONTENT);
        p.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM, rootView.getId());
        p.addRule(RelativeLayout.CENTER_HORIZONTAL, rootView.getId());
        layout.addView(adView, p);
        //layout.addView(adView);
        AdRequest adRequest = new AdRequest.Builder().build();
        try {
        adView.loadAd(adRequest);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return rootView;
    }

    @Override
    public void onDestroy() {
        adView.destroy();
        super.onDestroy();
    }

    @Override
    public void onPause() {
        adView.pause();
        super.onPause();
    }

    @Override
    public void onResume() {
        super.onResume();
        adView.resume();
    }
}

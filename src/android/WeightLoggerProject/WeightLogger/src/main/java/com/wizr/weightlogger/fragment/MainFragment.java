package com.wizr.weightlogger.fragment;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;

import com.wizr.weightlogger.MainActivity;
import com.wizr.weightlogger.R;

/**
 * Created by takuya.watabe on 8/6/13.
 */
public class MainFragment extends Fragment {
    public MainFragment() {
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_main, container, false);
        Button inputButton = (Button)rootView.findViewById(R.id.button_input_weight);
        inputButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                MainActivity activity = (MainActivity)getActivity();
                activity.showInputDialog();
            }
        });
        return rootView;
    }
}

package com.wizr.weightlogger.fragment;

import android.app.Dialog;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.support.v4.app.DialogFragment;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.DatePicker;
import android.widget.EditText;

import com.wizr.weightlogger.R;
import com.wizr.weightlogger.data.WeightData;
import com.wizr.weightlogger.data.WeightDataCollection;

import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

/**
 * Created by takuya on 8/10/13.
 */
public class InputDialogFragment extends DialogFragment {
    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        Dialog dialog = new Dialog(getActivity());
        // タイトル非表示
        dialog.getWindow().requestFeature(Window.FEATURE_NO_TITLE);
        // フルスクリーン
        dialog.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN);
        dialog.setContentView(R.layout.fragment_input_dialog);

        final EditText editText = (EditText)(dialog.findViewById(R.id.weight_text_input));
        final DatePicker datePicker = (DatePicker)(dialog.findViewById(R.id.datePicker));

        dialog.findViewById(R.id.dialog_ok_button).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String weightText = editText.getText().toString();

                if (!weightText.isEmpty()) {
                    Float weight = Float.valueOf(weightText);

                    Calendar cal = new GregorianCalendar(
                            datePicker.getYear(),
                            datePicker.getMonth(),
                            datePicker.getDayOfMonth(),
                            0, 0, 0
                    );
                    Date date = cal.getTime();

                    WeightData weightData = new WeightData(date.getTime(), weight);
                    WeightDataCollection collection = WeightDataCollection.getCollection(view.getContext());
                    collection.add(weightData);
                    collection.save();
                }

                dismiss();
            }
        });

        dialog.findViewById(R.id.dialog_cancel_button).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dismiss();
            }
        });
        /*
        // OK ボタンのリスナ
        dialog.findViewById(R.id.positive_button).setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                dismiss();
            }
        });
        // Close ボタンのリスナ
        dialog.findViewById(R.id.close_button).setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                dismiss();
            }
        });
        */

        return dialog;
    }
}

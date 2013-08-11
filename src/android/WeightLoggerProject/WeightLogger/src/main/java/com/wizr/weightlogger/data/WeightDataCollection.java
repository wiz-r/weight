package com.wizr.weightlogger.data;

import android.content.Context;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

/**
 * Created by takuya on 8/11/13.
 */
public class WeightDataCollection {
    private static final String SP_KEY = "weight_data";

    private HashMap<Long, WeightData> data = new HashMap<Long, WeightData>(){{
        put(1375887600L, new WeightData(1375887600L, 75.1F));
        put(1375974000L, new WeightData(1375974000L, 75.0F));
        put(1376060400L, new WeightData(1376060400L, 74.8F));
        put(1376146800L, new WeightData(1376146800L, 74.2F));
    }};
    //private HashMap<Long, WeightData> data = new HashMap<Long, WeightData>();
    private Context context;

    public WeightDataCollection(Context context)
    {
        this.context = context;
    }

    public void add(WeightData weightData) {
        data.put(weightData.getTimestamp(), weightData);
    }

    public void save() {
        JSONObject json = new JSONObject();
        try {
            HashMap<Long, Float> map = new HashMap<Long, Float>();
            for (Map.Entry<Long, WeightData> entry : data.entrySet()) {
                json.put(entry.getValue().getTimestamp().toString(), entry.getValue().getWeight().toString());
            }
            String jsonString = json.toString();

            SharedPreferences pref = PreferenceManager.getDefaultSharedPreferences(context);
            SharedPreferences.Editor editor = pref.edit();
            editor.putString(SP_KEY, jsonString);
            editor.commit();
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    public void load() {
        SharedPreferences pref = PreferenceManager.getDefaultSharedPreferences(context);
        String jsonString = pref.getString(SP_KEY, "");

        if (jsonString.isEmpty()) {
            data.clear();
            return;
        }

        HashMap<Long, Float> map = new HashMap<Long, Float>();

        try {
            JSONObject json = new JSONObject(jsonString);
            Iterator keys = json.keys();

            while (keys.hasNext()) {
                String key = (String)keys.next();
                String value = (String)json.get(key);
                map.put(Long.valueOf(key), Float.valueOf(value));
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }

        data.clear();
        for (Map.Entry<Long, Float> entry : map.entrySet()) {
            data.put(entry.getKey(), new WeightData(entry.getKey(), entry.getValue()));
        }
    }

    public WeightData[] getArray() {
        ArrayList list = new ArrayList<WeightData>();
        for(Map.Entry<Long, WeightData> entry : data.entrySet()) {
            list.add(entry.getValue());
        }

        if (list.isEmpty()) {
            return new WeightData[0];
        }

        Collections.sort(list, new WeightDataComparator());

        WeightData[] array = (WeightData[])list.toArray(new WeightData[list.size()]);
        return array;
    }
}

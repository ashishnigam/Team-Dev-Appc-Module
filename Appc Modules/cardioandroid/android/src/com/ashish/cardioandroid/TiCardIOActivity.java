package com.ashish.cardioandroid;

import org.appcelerator.titanium.util.Log;

import org.appcelerator.kroll.KrollFunction;
import org.appcelerator.kroll.KrollProxy;
import org.appcelerator.kroll.KrollEventCallback;

import io.card.payment.CardIOActivity;
import io.card.payment.CreditCard;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

public class TiCardIOActivity extends Activity {
	
	final String LCAT = getClass().getName();
	
	private int MY_SCAN_REQUEST_CODE = 100; // arbitrary int
	public static final String EXTRA_REQUIRE_EXPIRY = "EXTRA_REQUIRE_EXPIRY";
	public static final String EXTRA_REQUIRE_CVV = "EXTRA_REQUIRE_CVV";
	public static final String EXTRA_REQUIRE_POSTAL_CODE = "EXTRA_REQUIRE_POSTAL_CODE";
	public static final String EXTRA_SUPPRESS_MANUAL_ENTRY = "EXTRA_SUPPRESS_MANUAL_ENTRY";
	public static final String EXTRA_SCAN_RESULT = "EXTRA_SCAN_RESULT";
	
	public static KrollFunction successCallback = null;
	public static KrollFunction cancelCallback =  null;
	public static KrollFunction cancelCallbackOnCancel = null;
	
	TiCardIOActivity thisActivity = null;
	Intent classIntent = null;

	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		android.util.Log.i(LCAT, "onCreate-TiCardIOActivity myImplementation" + this.toString());
		thisActivity = this;
		android.util.Log.i(LCAT, "onCreate-TiCardIOActivity myImplementation" + thisActivity.toString());
		Intent scanIntent = new Intent(this, CardIOActivity.class);
		
		classIntent = getIntent();
        Bundle extras = classIntent.getExtras();
        
        Boolean expiry = extras.getBoolean(EXTRA_REQUIRE_EXPIRY, true);
        Boolean cvv = extras.getBoolean(EXTRA_REQUIRE_CVV,true);
        Boolean postalCode = extras.getBoolean(EXTRA_REQUIRE_POSTAL_CODE,false);
        Boolean manualEntry = extras.getBoolean(EXTRA_SUPPRESS_MANUAL_ENTRY,false);
        
        android.util.Log.i(LCAT, "testthesevalues: "+expiry + " " + cvv + " " + " " + postalCode + " as " + manualEntry);

		// customize these values to suit your needs.
		scanIntent.putExtra(CardIOActivity.EXTRA_REQUIRE_EXPIRY, expiry); // default:
																		// false
		scanIntent.putExtra(CardIOActivity.EXTRA_REQUIRE_CVV, cvv); // default:
																		// false
		scanIntent.putExtra(CardIOActivity.EXTRA_REQUIRE_POSTAL_CODE, postalCode); // default:
																				// false

		// hides the manual entry button
		// if set, developers should provide their own manual entry mechanism in
		// the app
		scanIntent.putExtra(CardIOActivity.EXTRA_SUPPRESS_MANUAL_ENTRY, manualEntry); // default:
																				// false

		// matches the theme of your application
		scanIntent.putExtra(CardIOActivity.EXTRA_KEEP_APPLICATION_THEME, true); // default:
																					// false

		// MY_SCAN_REQUEST_CODE is arbitrary and is only used within this
		// activity.
		startActivityForResult(scanIntent, MY_SCAN_REQUEST_CODE);

	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		CreditCard scanResult = data.getParcelableExtra(CardIOActivity.EXTRA_SCAN_RESULT);
		android.util.Log.i(LCAT, "requestCode = "+ requestCode + "resultCode= " + resultCode + "cardNumber= "+ scanResult.expiryMonth
				+ "/" + scanResult.expiryYear + "card no= " + scanResult.getRedactedCardNumber());
		android.util.Log.i(LCAT, "onActivityResult myImplementation");
		// Just pass on this result upstream
		setResult(resultCode, data);
		//thisActivity.setResult(resultCode);
		//fireEvent("success", requestCode);
		finish();
	}
}
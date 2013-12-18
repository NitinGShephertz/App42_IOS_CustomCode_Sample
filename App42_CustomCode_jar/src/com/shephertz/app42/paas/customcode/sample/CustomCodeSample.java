/**
 * 
 */
package com.shephertz.app42.paas.customcode.sample;

import org.json.JSONException;
import org.json.JSONObject;

import com.shephertz.app42.paas.customcode.Executor;
import com.shephertz.app42.paas.customcode.HttpRequestObject;
import com.shephertz.app42.paas.customcode.HttpResponseObject;
import com.shephertz.app42.paas.sdk.java.App42Exception;
import com.shephertz.app42.paas.sdk.java.App42NotFoundException;
import com.shephertz.app42.paas.sdk.java.ServiceAPI;
import com.shephertz.app42.paas.sdk.java.log.LogService;
import com.shephertz.app42.paas.sdk.java.user.User;
import com.shephertz.app42.paas.sdk.java.user.UserService;

/**
 * @author Himanshu Sharma
 * 
 */
public class CustomCodeSample implements Executor {

	/**
	 * @param args
	 */
	private static String apiKey = "";
	private static String secretKey = "";
	private static String userName = "";
	private static String password = "";
	private static String emailId = "";
	private static int HTTP_STATUS_SUCCESS = 200;
	private static String moduleName = "";

	@Override
	public HttpResponseObject execute(HttpRequestObject request) {
		JSONObject body = request.getBody();
		ServiceAPI sp =null;
		try {
			if(body.getString("apiKey")!= null || body.getString("apiKey")!= "" || body.getString("secretKey")!= null || body.getString("secretKey")!= ""){
				apiKey = body.getString("apiKey");
				secretKey = body.getString("secretKey");
				sp =  new ServiceAPI(apiKey, secretKey);
			}
			if(body.getString("userName")!= null || body.getString("userName")!= ""){
				userName = body.getString("userName");
			}
			if(body.getString("password")!= null || body.getString("password")!= ""){
				password = body.getString("password");
			}
			if(body.getString("emailId")!= null || body.getString("emailId")!= ""){
				emailId = body.getString("emailId");
			}
			if(body.getString("moduleName")!= null || body.getString("moduleName")!= ""){
				moduleName =  body.getString("moduleName");
			}
			
		} catch (JSONException e1) {
			LogService logger = sp.buildLogService();
			logger.error("JSON Error :" , e1.getMessage());
		}
		LogService logger = sp.buildLogService();
		
		// Build Log Service For logging in Your Code
		logger.debug(" Recieved Request Body : :" + body.toString(), moduleName);

		// Write Your Custom Code Here
		// ......//
		JSONObject jsonResponse = new JSONObject();
		logger.info("Running Custom Code  ", moduleName);
		UserService userService = sp.buildUserService();
		try {
			User createUser = userService.createUser(userName, password,
					emailId);
			if(createUser.isResponseSuccess()){
				User authUser = userService.authenticate(userName,
						password);
				jsonResponse.put(moduleName,authUser);
			}
		} catch (App42Exception exception) {
			if (exception.getAppErrorCode() == 2001) {
				try {
					User authCatchUser = userService.authenticate(userName,
							password);
					jsonResponse.put(moduleName,authCatchUser);
				} catch (App42NotFoundException notFoundException) {
					logger.error("App42Exception :  ", notFoundException.getMessage());
				} catch (JSONException e) {
					logger.error("App42Exception : ", e.getMessage());
				}
				
			}
			else
			{
				logger.error("App42Exception :  ", exception.getMessage());
			}
		} catch (JSONException e) {
			logger.error("JSON Exception :  ", e.getMessage());
			
		}
		// Return JSON Response and Status Code
		return new HttpResponseObject(HTTP_STATUS_SUCCESS, jsonResponse);
	}
}

exports.handler = async (event) => {
    // Cognito configuration for Lambda
    const cognitoConfig = {
        userPoolId: 'us-east-1_Tnb6JZNY0',  // Cognito User Pool ID
        userPoolClientId: '658bo70ggtnoa15puq3ek7j4o5',  // Cognito Client ID
        region: 'us-east-1'  // Cognito region
    };

    console.log("Cognito configuration:", cognitoConfig);
    console.log("Hello, World!");

    // Lambda response
    return {
        statusCode: 200,
        body: JSON.stringify({
            message: 'Hello, World!',
            cognitoConfig: cognitoConfig  // Include config info in the response (optional)
        }),
    };
};

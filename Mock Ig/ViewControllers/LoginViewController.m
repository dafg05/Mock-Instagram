//
//  LoginViewController.m
//  Mock Ig
//
//  Created by Daniel Flores Garcia on 6/27/22.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end



@implementation LoginViewController

NSString * const EMPTY_FIELDS_ERROR_MSSG = @"Either your username or password is empty";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)loginUser {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSString *errorMessage = [NSString stringWithFormat:@"%@", error.localizedDescription];
            [self loginAlert:@"Login error" :errorMessage];
            NSLog(@"User log in failed: %@", error.localizedDescription);
            
        } else {
            NSLog(@"User logged in successfully");
            // display view controller that needs to shown after successful login
            [self performSegueWithIdentifier:@"LoginSegue" sender:nil];
        }
    }];
}

- (void)registerUser {
    PFUser *newUser = [PFUser user];
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSString *errorMessage = [NSString stringWithFormat:@"%@", error.localizedDescription];
            [self loginAlert:@"Sign-up error" :errorMessage];
            NSLog(@"Error: %@", error.localizedDescription);
            
        } else {
            NSLog(@"User registered successfully");
            // manually segue to tab bar controller
            [self performSegueWithIdentifier:@"LoginSegue" sender:nil];
        }
    }];
}

- (void)loginAlert:(NSString *)title :(NSString *)errorMessage{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                   message:errorMessage
                                   preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
       handler:^(UIAlertAction * action) {}];

    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}


- (IBAction)didTapLogin:(id)sender {
    if ([self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""]){
        [self loginAlert:@"Login Error" :EMPTY_FIELDS_ERROR_MSSG];
    }else{
        NSLog(@"logging in!");
        [self loginUser];
    }
}

- (IBAction)didTapSignup:(id)sender {
    if ([self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""]){
        [self loginAlert:@"Signup Error" :EMPTY_FIELDS_ERROR_MSSG];
    } else{
    [self registerUser];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

#import "FAPSettingsViewController.h"


@interface FAPSettingsViewController() <UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) UIVisualEffectView *blurEffectView;
@property (weak, nonatomic) NSUserDefaults *userDefaults;
@end

@implementation  FAPSettingsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepare];

    self.userDefaults = [NSUserDefaults standardUserDefaults];


    self.tableView = [[UITableView alloc] initWithFrame:self.blurEffectView.frame style:UITableViewStyleInsetGrouped];
    self.tableView.backgroundColor = UIColor.clearColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.blurEffectView.contentView addSubview:self.tableView];
    
}

- (void)prepare{
    self.title = @"Fix Apple Pay";
    self.view.backgroundColor = UIColor.clearColor;
    
    self.blurEffectView = [[UIVisualEffectView alloc]
        initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular]];
    self.blurEffectView.frame = self.view.frame;
    self.view = self.blurEffectView;

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemClose
        target:self
        action:@selector(closeTapped)];
}

-(void)closeTapped{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// MARK: UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 2;
    }
    return 3;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Spoofing";
        case 1:
            return @"IDK Others";
        default:
            return nil;
    
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if(section == (tableView.numberOfSections -1)){
    return @"Licensed under the Unlicense By @ExTBH, TrollStore Version";
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }

    cell.detailTextLabel.textColor = UIColor.tertiaryLabelColor;
    cell.backgroundColor = [UIColor.systemGroupedBackgroundColor colorWithAlphaComponent:0.5];


    if(indexPath.section == 0){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        UITextField *textField = [UITextField new];
        textField.delegate = self;
        textField.returnKeyType = UIReturnKeyDone;
        textField.tag = indexPath.row;
        textField.textAlignment = NSTextAlignmentRight;
        textField.translatesAutoresizingMaskIntoConstraints = NO;
        [cell.contentView addSubview:textField];

        [NSLayoutConstraint activateConstraints:@[
            [textField.heightAnchor constraintEqualToConstant:44],
            [textField.leadingAnchor constraintEqualToAnchor:cell.textLabel.safeAreaLayoutGuide.trailingAnchor],
            [textField.trailingAnchor constraintEqualToAnchor:cell.layoutMarginsGuide.trailingAnchor],
            [textField.centerYAnchor constraintEqualToAnchor:cell.contentView.centerYAnchor],
            [textField.widthAnchor constraintEqualToConstant:100]
            ]];

        NSString *rowAsString = [@(indexPath.row) stringValue];
        NSString *stringForRow = [self.userDefaults stringForKey:rowAsString];
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Spoofed Version:";
                cell.detailTextLabel.text = @"increment until you find a working version";
                textField.placeholder = @"15.3";
                break;
            case 1:
                cell.textLabel.text = @"Spoofed Build:";
                cell.detailTextLabel.text = @"as of writing this, this doesn't really matter";
                textField.placeholder = @"19D50";
                break;
            default:
                cell.textLabel.text = @"Something is wrong";
        }
        if(stringForRow){
            textField.text = stringForRow;
        }
    }
    else if (indexPath.section == 1) {
        cell.textLabel.textColor = UIColor.systemBlueColor;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Source Code";
                cell.detailTextLabel.text = @"On Github";
                break;
            case 1:
                cell.textLabel.text = @"Bugs";
                cell.detailTextLabel.text = @"@ExTBH";
                break;
            case 2:
                cell.textLabel.text = @"License";
                break;
            default:
                cell.textLabel.text = @"Something is wrong";
        }
    
    }
    
    

    return cell;
}

// MARK: UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1){
        NSString *urlToOpen;
        switch (indexPath.row) {
            case 0:
                urlToOpen = @"https://github.com/ExTBH/iOS14-fix-apple-pay/";
                break;
            case 1:
                urlToOpen = @"https://twitter.com/ExTBH/";
                break;
            case 2:
                urlToOpen = @"https://unlicense.org/";
                break;
        }

        [UIApplication.sharedApplication openURL:[NSURL URLWithString:urlToOpen] options:@{} completionHandler:nil];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


// MARK: UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self.userDefaults setObject:textField.text forKey:[@(textField.tag) stringValue ]];
    return YES;
}
@end
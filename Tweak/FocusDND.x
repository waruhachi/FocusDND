#import <FocusDND.h>

%hook CCUIModuleSettingsManager

- (CCUIModuleSettings *)moduleSettingsForModuleIdentifier:(NSString *)identifier prototypeSize:(CCUILayoutSize)protoSize {
	if (![identifier isEqualToString:focusModuleIdentifier]) return %orig;

	return [[%c(CCUIModuleSettings) alloc] initWithPortraitLayoutSize:defaultLayoutSize landscapeLayoutSize:defaultLayoutSize];
}

%end

%hook FCCCModuleViewController

- (void)_updateTitle:(id)title on:(BOOL)isActive buttonSize:(CGSize)buttonSize {
	%orig(@"", NO, buttonSize);
}

%end

%hook CCUILabeledRoundButton

- (void)setFrame:(CGRect)frame {
	if ([[self.superview _viewControllerForAncestor] isKindOfClass:%c(FCCCModuleViewController)]) {
		frame = self.superview.bounds;
		self.buttonView.normalStateBackgroundView.hidden = true;
	}

	%orig(frame);
}

%end

%hook CCUIRoundButton

- (void)setFrame:(CGRect)frame {
	if ([[self.superview.superview _viewControllerForAncestor] isKindOfClass:%c(FCCCModuleViewController)]) frame = self.superview.superview.bounds;

	%orig(frame);
}

- (void)_setCornerRadius:(CGFloat)cornerRadius {
	if ([[self.superview.superview _viewControllerForAncestor] isKindOfClass:%c(FCCCModuleViewController)]) {
		UIView *materialView = self.superview.superview.superview.subviews.firstObject;
		if (![materialView isKindOfClass:%c(MTMaterialView)]) return;

		self.layer.cornerCurve = kCACornerCurveContinuous;
		cornerRadius = materialView.layer.cornerRadius;
	}

	%orig(cornerRadius);
}

%end

%ctor {
	[[NSNotificationCenter defaultCenter] addObserverForName:NSBundleDidLoadNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
		NSString *bundlePath = ((NSBundle *)notification.object).bundlePath;

		if ([bundlePath isEqualToString:focusModuleBundlePath]) %init;
	}];
}

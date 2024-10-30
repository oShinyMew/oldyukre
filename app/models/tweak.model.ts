export interface Tweak {
    name: string;
    description: string;
    supportedVersions: string[];
    author: string;
    isEnabled: boolean;
}

export interface JailbreakStatus {
    isJailbroken: boolean;
    progress: number;
    currentStep: string;
    deviceVersion: string;
}
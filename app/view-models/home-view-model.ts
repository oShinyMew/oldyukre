import { Observable } from '@nativescript/core';
import { Tweak, JailbreakStatus } from '../models/tweak.model';

export class HomeViewModel extends Observable {
    private _jailbreakStatus: JailbreakStatus;
    private _availableTweaks: Tweak[];
    private _isJailbreaking: boolean;

    constructor() {
        super();
        this._isJailbreaking = false;
        this._jailbreakStatus = {
            isJailbroken: false,
            progress: 0,
            currentStep: 'Ready to jailbreak',
            deviceVersion: '15.0 - 16.4.1'
        };
        this._availableTweaks = [
            {
                name: 'System Tweak Pro',
                description: 'Enhanced system customization',
                supportedVersions: ['15.0', '15.1', '15.2'],
                author: 'YukreTeam',
                isEnabled: false
            },
            {
                name: 'Security Plus',
                description: 'Advanced security features',
                supportedVersions: ['15.0', '15.1', '15.2', '16.4.1'],
                author: 'YukreTeam',
                isEnabled: false
            }
        ];
    }

    get jailbreakStatus(): JailbreakStatus {
        return this._jailbreakStatus;
    }

    get availableTweaks(): Tweak[] {
        return this._availableTweaks;
    }

    get isJailbreaking(): boolean {
        return this._isJailbreaking;
    }

    async startJailbreak() {
        if (this._isJailbreaking) return;
        
        this._isJailbreaking = true;
        this.notifyPropertyChange('isJailbreaking', true);
        
        // Simulate jailbreak process
        for (let i = 0; i <= 100; i += 10) {
            this._jailbreakStatus.progress = i;
            this._jailbreakStatus.currentStep = this.getStepDescription(i);
            this.notifyPropertyChange('jailbreakStatus', this._jailbreakStatus);
            await new Promise(resolve => setTimeout(resolve, 500));
        }

        this._jailbreakStatus.isJailbroken = true;
        this._isJailbreaking = false;
        this.notifyPropertyChange('isJailbreaking', false);
        this.notifyPropertyChange('jailbreakStatus', this._jailbreakStatus);
    }

    private getStepDescription(progress: number): string {
        if (progress === 0) return 'Preparing device...';
        if (progress < 30) return 'Exploiting kernel...';
        if (progress < 60) return 'Patching system...';
        if (progress < 90) return 'Installing tweaks...';
        return 'Finalizing...';
    }

    toggleTweak(index: number) {
        this._availableTweaks[index].isEnabled = !this._availableTweaks[index].isEnabled;
        this.notifyPropertyChange('availableTweaks', this._availableTweaks);
    }
}
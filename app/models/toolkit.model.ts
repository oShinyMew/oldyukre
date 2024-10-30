export interface Tool {
    id: string;
    name: string;
    description: string;
    supportedVersions: string[];
    category: 'system' | 'security' | 'network' | 'diagnostics';
    isEnabled: boolean;
    requiresRoot: boolean;
}

export interface SystemStatus {
    deviceVersion: string;
    batteryLevel: number;
    storageUsed: string;
    ramUsage: string;
    cpuUsage: string;
    networkType: string;
}
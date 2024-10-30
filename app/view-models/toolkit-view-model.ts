import { Observable } from '@nativescript/core';
import { Tool, SystemStatus } from '../models/toolkit.model';

export class ToolkitViewModel extends Observable {
    private _systemStatus: SystemStatus;
    private _availableTools: Tool[];
    private _selectedCategory: string;

    constructor() {
        super();
        this._selectedCategory = 'all';
        this._systemStatus = {
            deviceVersion: '16.4.1',
            batteryLevel: 85,
            storageUsed: '75.5 GB / 128 GB',
            ramUsage: '3.2 GB / 4 GB',
            cpuUsage: '32%',
            networkType: 'Wi-Fi'
        };
        this._availableTools = [
            {
                id: 'system_cleaner',
                name: 'System Cleaner',
                description: 'Clean system cache and temporary files',
                supportedVersions: ['15.0-16.4.1'],
                category: 'system',
                isEnabled: true,
                requiresRoot: false
            },
            {
                id: 'network_toolkit',
                name: 'Network Toolkit',
                description: 'Advanced networking tools and packet analysis',
                supportedVersions: ['15.0-16.4.1'],
                category: 'network',
                isEnabled: true,
                requiresRoot: true
            },
            {
                id: 'security_scanner',
                name: 'Security Scanner',
                description: 'Scan for vulnerabilities and security issues',
                supportedVersions: ['15.0-16.4.1'],
                category: 'security',
                isEnabled: true,
                requiresRoot: true
            },
            {
                id: 'diagnostics',
                name: 'System Diagnostics',
                description: 'Comprehensive system health check and analysis',
                supportedVersions: ['15.0-16.4.1'],
                category: 'diagnostics',
                isEnabled: true,
                requiresRoot: false
            },
            {
                id: 'kernel_info',
                name: 'Kernel Info',
                description: 'Display detailed kernel information and parameters',
                supportedVersions: ['15.0-16.4.1'],
                category: 'system',
                isEnabled: true,
                requiresRoot: true
            },
            {
                id: 'network_monitor',
                name: 'Network Monitor',
                description: 'Real-time network traffic analysis and monitoring',
                supportedVersions: ['15.0-16.4.1'],
                category: 'network',
                isEnabled: true,
                requiresRoot: true
            }
        ];
    }

    get systemStatus(): SystemStatus {
        return this._systemStatus;
    }

    get availableTools(): Tool[] {
        return this._selectedCategory === 'all' 
            ? this._availableTools 
            : this._availableTools.filter(tool => tool.category === this._selectedCategory);
    }

    get selectedCategory(): string {
        return this._selectedCategory;
    }

    setCategory(args: { object: any, param: string }) {
        this._selectedCategory = args.param;
        this.notifyPropertyChange('availableTools', this.availableTools);
        this.notifyPropertyChange('selectedCategory', args.param);
    }

    async runTool(args: { object: any, param: string }) {
        const toolId = args.param;
        const tool = this._availableTools.find(t => t.id === toolId);
        if (!tool) return;

        tool.isEnabled = false;
        this.notifyPropertyChange('availableTools', this.availableTools);

        // Simulate tool execution
        await new Promise(resolve => setTimeout(resolve, 2000));

        tool.isEnabled = true;
        this.notifyPropertyChange('availableTools', this.availableTools);
    }

    updateSystemStatus() {
        // Simulate real-time updates
        this._systemStatus.cpuUsage = `${Math.floor(Math.random() * 100)}%`;
        this._systemStatus.ramUsage = `${(Math.random() * 4).toFixed(1)} GB / 4 GB`;
        this.notifyPropertyChange('systemStatus', this._systemStatus);
    }
}
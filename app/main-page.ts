import { NavigatedData, Page } from '@nativescript/core';
import { ToolkitViewModel } from './view-models/toolkit-view-model';

export function navigatingTo(args: NavigatedData) {
    const page = <Page>args.object;
    const viewModel = new ToolkitViewModel();
    
    // Update system status every 5 seconds
    setInterval(() => viewModel.updateSystemStatus(), 5000);
    
    page.bindingContext = viewModel;
}
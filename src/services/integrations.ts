import type { Integration, UpdateInfo } from '../types/admin';

export const installIntegration = async (integration: Integration): Promise<boolean> => {
  try {
    const response = await fetch('/api/admin/integrations/install', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        integration: integration.id,
      }),
    });

    if (!response.ok) {
      throw new Error('Error installing integration');
    }

    return true;
  } catch (error) {
    console.error('Error installing integration:', error);
    return false;
  }
};

export const uninstallIntegration = async (integration: Integration): Promise<boolean> => {
  try {
    const response = await fetch(`/api/admin/integrations/${integration.id}/uninstall`, {
      method: 'POST',
    });

    if (!response.ok) {
      throw new Error('Error uninstalling integration');
    }

    return true;
  } catch (error) {
    console.error('Error uninstalling integration:', error);
    return false;
  }
};

export const toggleIntegration = async (integration: Integration, action: 'start' | 'stop' | 'restart'): Promise<boolean> => {
  try {
    const response = await fetch(`/api/admin/integrations/${integration.id}/${action}`, {
      method: 'POST',
    });

    if (!response.ok) {
      throw new Error(`Error ${action}ing integration`);
    }

    return true;
  } catch (error) {
    console.error(`Error ${action}ing integration:`, error);
    return false;
  }
};

export const getIntegrationStatus = async (integration: Integration): Promise<{
  installed: boolean;
  running: boolean;
  version: string;
  error?: string;
}> => {
  try {
    const response = await fetch(`/api/admin/integrations/${integration.id}/status`);
    
    if (!response.ok) {
      throw new Error('Error getting integration status');
    }

    return await response.json();
  } catch (error) {
    console.error('Error getting integration status:', error);
    return {
      installed: false,
      running: false,
      version: integration.version,
      error: 'Error checking status',
    };
  }
};

export const checkForUpdates = async (integration: Integration): Promise<UpdateInfo | null> => {
  try {
    const response = await fetch(`/api/admin/integrations/${integration.id}/updates`);
    
    if (!response.ok) {
      throw new Error('Error checking for updates');
    }

    return await response.json();
  } catch (error) {
    console.error('Error checking for updates:', error);
    return null;
  }
};

export const updateIntegration = async (integration: Integration): Promise<boolean> => {
  try {
    const response = await fetch(`/api/admin/integrations/${integration.id}/update`, {
      method: 'POST',
    });

    if (!response.ok) {
      throw new Error('Error updating integration');
    }

    return true;
  } catch (error) {
    console.error('Error updating integration:', error);
    return false;
  }
};
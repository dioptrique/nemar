import torch
from torch import nn

from .layers import DownBlock


class AffineNetwork(nn.Module):
    def __init__(self):
        super(AffineNetwork, self).__init__()
        self.device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
        self.convs = nn.Sequential(
            DownBlock(4, 32, 3, 1, 1, True, 'leaky_relu', 'kaiming', False, True, False, True, True),
            DownBlock(32, 64, 3, 1, 1, True, 'leaky_relu', 'kaiming', False, True, False, True, True),
            DownBlock(64, 64, 3, 1, 1, True, 'leaky_relu', 'kaiming', False, True, False, True, True),
            # DownBlock(64, 64, 3, 1, 1, True, 'leaky_relu', 'kaiming', False, True, False, True, True),
            # DownBlock(32, 32, 3, 1, 1, True, 'leaky_relu', 'kaiming', False, True, False, True, True),
        )
        self.local = nn.Sequential(nn.Linear(4*8*32 * 9 * 12, 32, True),
                                   nn.LeakyReLU(negative_slope=0.2),
                                   nn.Linear(32, 32, True),
                                   nn.LeakyReLU(negative_slope=0.2),
                                   nn.Linear(32, 6, True))

        self.local[-1].weight.data.zero_()
        self.local[-1].bias.data.zero_()
        self.identity_theta = torch.tensor([1, 0, 0, 0, 1, 0], dtype=torch.float).to(self.device)

    def forward(self, x):
        x = self.convs(x)
        x = x.view(-1, 4*8*32 * 9 * 12)
        dtheta = self.local(x)
        theta = dtheta + self.identity_theta
        theta = theta.view(-1, 2, 3)
        return theta, dtheta

"""Unfinished simulation code."""
import numpy as np


def simulate_features(n_samples, n_features):
    x = np.random.normal(size=(n_samples, n_features))
    return x


def create_coefs(n_features):
    coef = np.round(0.7 ** np.random.randint(1, 8, (1 + n_features)), 2)
    return coef


def linear_model_part(x, coef):
    linear_part = coef[0] + x @ coef[1:]
    return linear_part


def logistic_function(u):
    return 1 / (1 + np.exp(-u))


def simulate_true_probs(x, coef):
    lm_part = linear_model_part(x, coef)
    prob = logistic_function(lm_part)
    return prob


def simulate_response(prob):
    y = np.random.binomial(1, prob)
    return y


def data_generating_process(n_features, n_samples):

    x = simulate_features()
    coef = create_coefs(x.shape[1])
    prob = simulate_true_probs(x, coef)
    y = simulate_response(prob)

    x = simulate_features(n_features, n_samples)
    coef = create_coefs(n_features)  # create_coefs(n_features)
    true_probs = simulate_true_probs(x, coef)
    y = simulate_response(true_probs)

    return x, y

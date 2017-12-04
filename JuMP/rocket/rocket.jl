#
# Optimization based rocket control simulation
#
# author: Atsushi Sakai
#

using PyCall, JuMP, Ipopt

@pyimport matplotlib.pyplot as plt

function main()
    println(PROGRAM_FILE," start!!")
    mod = Model(solver=IpoptSolver(print_level=0))

    # Constants
    # Note that all parameters in the model have been normalized
    # to be dimensionless. See the COPS3 paper for more info.
    h_0 = 1    # Initial height
    v_0 = 0    # Initial velocity
    m_0 = 1    # Initial mass
    g_0 = 1    # Gravity at the surface

    # Parameters
    T_c = 3.5  # Used for thrust
    v_c = 620  # Used for drag
    h_c = 300.0 # parameter of drag
    m_c = 0.6  # Fraction of initial mass left at end

    # Derived parameters
    c     = 0.5*sqrt(g_0*h_0)  # Thrust-to-fuel mass
    m_f   = m_c*m_0            # Final mass
    D_c   = 0.5*v_c*m_0/g_0    # Drag scaling
    T_max = T_c*g_0*m_0        # Maximum thrust

    n = 100   # Time steps

    # State variables
    @variable(mod, v[0:n] ≥ 0)            # Velocity
    @variable(mod, h[0:n] ≥ h_0)          # Height
    @variable(mod, m_f ≤ m[0:n] ≤ m_0)    # Mass
    @variable(mod, Δt ≥ 0, start = 1/n)   # Time step

    # Control: thrust
    @variable(mod, 0 ≤ T[0:n] ≤ T_max)
 
    # Objective: maximize altitude at end of time of flight
    @objective(mod, Max, h[n])

    @expression(mod, t_f, Δt*n)          # Time of flight

    # Initial conditions
    @constraint(mod, v[0] == v_0)
    @constraint(mod, h[0] == h_0)
    @constraint(mod, m[0] == m_0)
    @constraint(mod, m[n] == m_f)

    # Forces
    # Drag(h,v) = Dc v^2 exp( -hc * (h - h0) / h0 )
    @NLexpression(mod, drag[j=0:n], D_c*(v[j]^2)*exp(-h_c*(h[j]-h_0)/h_0))
    # Grav(h)   = go * (h0 / h)^2
    @NLexpression(mod, grav[j=0:n], g_0*(h_0/h[j])^2)

    # Dynamics
    for j in 1:n
        # h' = v Trapezoidal integration
        @NLconstraint(mod, h[j] == h[j-1] + 0.5*Δt*(v[j]+v[j-1]))

        # v' = (T-D(h,v))/m - g(h) Trapezoidal integration
        @NLconstraint(mod, v[j] == v[j-1] + 0.5*Δt*(
                (T[j  ] - drag[j  ] - m[j  ]*grav[j  ])/m[j  ] +
                (T[j-1] - drag[j-1] - m[j-1]*grav[j-1])/m[j-1] ))

        # m' = -T/c Trapezoidal integration
        @NLconstraint(mod, m[j] == m[j-1] - 0.5*Δt*(T[j] + T[j-1])/c)
    end

    # Provide starting solution
    for k in 0:n
        setvalue(h[k], 1)
        setvalue(v[k], (k/n)*(1 - (k/n)))
        setvalue(m[k], (m_f - m_0)*(k/n) + m_0)
        setvalue(T[k], T_max/2)
    end

    # Solve for the control and state
    status = solve(mod)

    # Display results
    plt.subplots(1)
    x=[getvalue(Δt)*i for i in 0:n]
    y=[getvalue(h[i]) for i in 0:n]
    plt.plot(x, y)
    plt.grid(true)
    plt.xlabel("Time[s]")
    plt.ylabel("Altitude")
    
    plt.subplots(1)
    y=[getvalue(m[i]) for i in 0:n]
    plt.plot(x, y)
    plt.xlabel("Time[s]")
    plt.ylabel("Mass")
    plt.grid(true)

    plt.subplots(1)
    y=[getvalue(v[i]) for i in 0:n]
    plt.plot(x, y)
    plt.xlabel("Time[s]")
    plt.ylabel("Velocity")
    plt.grid(true)

    plt.subplots(1)
    y=[getvalue(T[i]) for i in 0:n]
    plt.plot(x, y)
    plt.xlabel("Time[s]")
    plt.ylabel("Thrust")
    plt.grid(true)

    plt.show()

    println(PROGRAM_FILE," Done!!")
end


if contains(@__FILE__, PROGRAM_FILE)
    @time main()
end


